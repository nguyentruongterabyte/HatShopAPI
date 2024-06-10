<?php
namespace Src\Controller;

use Src\TableGateways\UserGateway;
use Src\Utils\Utils;

class UserController {
  private $db;
  private $requestMethod;
  private $userGateway;
  private $mail;
  private $key;
  private $reset;
  private $requestName;
  private $jwt;

  public function __construct($db, $requestMethod, $mail, $key, $reset, $requestName, $jwt) {
    $this->db = $db;
    $this->requestMethod = $requestMethod;
    $this->userGateway = new UserGateway($this->db);
    $this->mail = $mail;
    $this->key = $key;
    $this->reset = $reset;
    $this->requestName = $requestName;
    $this->jwt = $jwt;
  }

  public function processRequest() {
    switch ($this->requestMethod) {
      case 'GET':
        
        if ($this->requestName && strcasecmp($this->requestName, 'get-all') == 0) {
          $response = $this->getAll();
        } else if ($this->key && $this->reset) {
          header('Content-Type: text/html');
          $response = $this->resetPassword($this->key, $this->reset);
          return;
        } else {
          $response = Utils::forbiddenResponse("Forbidden");
        }
        break;
      case 'POST':
        switch($this->requestName) {
          case 'login':
            $response = $this->login();
            break;
          case 'register':
            $response = $this->register();
            break;
          case 'submit-new-password':
            $this->submitNewPassword();
            return;
          case 'reset-password-request':
            $response = $this->resetPasswordRequest();
            break;
          case 'refresh-token':
            $response = $this->refreshToken();
            break;
          default:
            $response = Utils::forbiddenResponse('Forbidden');
            break;
        }
        break;
      case 'PUT':
        break;
      case 'DELETE':
        break;
      default:
        $response = Utils::notFoundResponse("Phương thức không hợp lệ!");
        break;      
    }

    header($response['status_code_header']);
    if ($response['body']) {
      header('Content-Type: application/json');
      echo json_encode($response['body']);
    }
  }

  private function submitNewPassword() {
    $input = $_POST;
    // Nếu email bị thay đổi hoặc xóa lúc submit do
    // user sử dụng dev tools thì không được thay đổi mật khẩu
    if (!isset($input['key']) || !$input['key']) {
      return Utils::badRequestResponse('Có thể email đã bị thay đổi');
    }

    // Nếu người dùng thay đổi reset (tức là mật khẩu cũ)
    // thì không cho phép 
    if (!isset($input['reset']) || !$input['reset']) {
      return Utils::badRequestResponse('Có thể mật khẩu đã bị thay đổi');
    }

    $user = $this->userGateway->findByEmail($input['key']);
    if (!$user) {
      return Utils::badRequestResponse('Không tồn tại tài khoản này');
    }

    $password = $input['password'];
    $oldPassword = $input['reset'];

    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    $rowCount = $this->userGateway->updatePassword($user['email'], $hashedPassword);

    if ($oldPassword == $user['password']) {
      if ($rowCount > 0) {
        echo 'Thay đổi mật khẩu thành công. Bạn có thể thoát trang web';
      } else {
        echo 'Không được resumbit lại biểu mẫu này';
      }
    } else {
      echo 'Không được resubmit lại biểu mẫu này';
    }
    
  }

  private function getAll() {
    $result = $this->userGateway->getAll();
    $response = Utils::successResponse('Thành công');
    $response['body']['result'] = $result;
    return $response; 
  }

  private function register() {
    $input = $_POST;
    $response = $this->validateRegister($input); 
    if ($response['body']['status'] != 200) {
      return $response;
    }
    // mã hóa mật khẩu
    $input['hashedPassword'] = password_hash($input['password'], PASSWORD_DEFAULT);
    $rowCount = $this->userGateway->create($input);
    if ($rowCount > 0) {
      $response = Utils::successResponse('Đăng ký thành công');
      $user = $this->userGateway->findByEmail($input['email']);
      // xóa mật khẩu trước khi trả về cho user
      unset($user['password']);
      $response['body']['result'] = $user;
    } else {
      $response = Utils::badRequestResponse('Không có gì thay đổi');
    }
    return $response;
  }
    private function login() {
      $input = $_POST;
      if (!isset($input['email']) || !$input['email']) {
        return Utils::unprocessableEntityResponse('Chưa cung cấp email');
      }

      if (!isset($input['password']) || !$input['password']) {
        return Utils::unprocessableEntityResponse('Chưa cung cấp mật khẩu');
      }

      $user = $this->userGateway->findByEmail($input['email']);
      if (!$user) {
        return Utils::unauthorizedResponse('Email hoặc mật khẩu chưa đúng');
      }

      if (!password_verify($input['password'], $user['password'])) {
        return Utils::unauthorizedResponse('Email hoặc mật khẩu chưa đúng');
      }

      unset($user['password']);
      $response = Utils::successResponse('Đăng nhập thành công');

      // Tạo JWT và refresh token
      $jwt = $this->jwt->createJWT($user['id'], $user['roleId']);
      $refreshToken = $this->jwt->createRefreshToken($user['id']);

      // Lưu refresh token vào cookies
      setcookie('refreshToken', $refreshToken, time() + (86400 * 14), "/", "", false, true); // 14 ngày
      $user['accessToken'] = $jwt;
      $user['refreshToken'] = $refreshToken;
      $response['body']['result'] = $user;
      return $response;
    }

  private function refreshToken() {
    if (!isset($_POST['refreshToken'])) {
      return Utils::unauthorizedResponse('Không có refresh token');
    }

    $refreshToken = $_POST['refreshToken'];
    $decoded = $this->jwt->validateJWT($refreshToken);

    if (!$decoded || $decoded->type !== 'refresh') {
      return Utils::unauthorizedResponse('Refresh token không hợp lệ');
    }

    $userId = $decoded->sub;
    $user = $this->userGateway->find($userId);
    if (!$user) {
      return Utils::forbiddenResponse('Refresh token không hợp lệ');
    }
    $jwt = $this->jwt->createJWT($userId, $user['roleId']);

    $response = Utils::successResponse('Làm mới token thành công');
    $response['body']['result'] = $jwt;
    $response['body']['role'] = $user['roleId'];
    return $response;
  }

  private function validateRegister($input) {
    // Chưa nhập email
    if (!isset($input['email']) || !$input['email']) {
      return Utils::unprocessableEntityResponse("Chưa cung cấp email");
    }
    // Chưa nhập password
    else if (!isset($input['password']) || !$input['password']) {
      return Utils::unprocessableEntityResponse("Chưa cung cấp mật khẩu");
    } 
    // Chưa nhập tên người dùng
    else if (!isset($input['username']) || !$input['username']) {
      return Utils::unprocessableEntityResponse("Chưa cung cấp tên người dùng");
    // Chưa cung cấp số điện thoại
    } else if (!isset($input['mobile']) || !$input['mobile']) {
      return Utils::unprocessableEntityResponse("Chưa cung cấp số điện thoại");  
    } else if ($this->userGateway->isEmailExists($input['email'])) {
      return Utils::conflictResponse('Email đã tồn tại');
    } else {
      return Utils::successResponse('Pass');
    }
  }

  private function resetPasswordRequest() {

    $input = $_POST;
    if (!isset($input['email']) || !$input['email']) {
      return Utils::unprocessableEntityResponse('Chưa cung cấp email');
    }

    $user = $this->userGateway->findByEmail($input['email']);
    if (!$user) {
      return Utils::forbiddenResponse('Tài khoản chưa được đăng ký');
    }
    
    $email = $_POST['email'];
    $endPoint = getenv('END_POINT');
    $link = $endPoint . 'hatshop/api/user/reset-password?key=' . $user['email'] . '&reset=' . $user['password'] . '';
    $body = '
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Password Reset</title>
          <style>
              body {
                  font-family: Arial, sans-serif;
                  line-height: 1.6;
                  margin: 0;
                  padding: 0;
                  background-color: #f4f4f4;
              }
              .container {
                  max-width: 600px;
                  margin: 30px auto;
                  padding: 20px;
                  background-color: #fff;
                  border-radius: 8px;
                  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
              }
              .logo {
                  text-align: center;
                  margin-bottom: 20px;
              }
              .logo img {
                  width: 120px;
              }
              .message {
                  padding: 20px;
                  border-radius: 8px;
                  background-color: #f0f0f0;
                  text-align: center;
              }
              .btn {
                  display: inline-block;
                  padding: 10px 20px;
                  text-decoration: none;
                  background-color: #007bff;
                  color: #fff !important;
                  border-radius: 5px;
              }
          </style>
      </head>
      <body>
          <div class="container">
              <div class="logo">
                  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWpi3Ta6z2nsp0z0JbzozBH83y-LJjwIqm1xipJl8V5_IJMcSlbOjmLWX88Q&s" alt="Logo">
              </div>
              <div class="message">
                  <p>Chào bạn,</p>
                  <p>Bạn nhận được email này vì bạn đã yêu cầu đặt lại mật khẩu cho tài khoản của mình.</p>
                  <p>Vui lòng nhấn vào nút bên dưới để đặt lại mật khẩu của bạn:</p>
                  <p><a class="btn" href="'.$link.'">Đặt lại mật khẩu</a></p>
                  <p>Nếu bạn không yêu cầu thay đổi mật khẩu, vui lòng bỏ qua email này.</p>
              </div>
          </div>
      </body>
      </html>
    '
    ;
    // Địa chỉ email nhận
    $this->mail->AddAddress($email, 'receiver_name');
    // Email subject
    $this->mail->Subject = 'Đặt lại mật khẩu';
    // định dạng html
    $this->mail->IsHTML(true);
    // email body
    $this->mail->Body = $body;

    if ($this->mail->Send()) {
      $response = Utils::successResponse('Vui lòng kiểm tra email '.$email.' để thay đổi mật khẩu!');
    } else {
      $response = Utils::unprocessableEntityResponse('Đã có lỗi xảy ra với gửi mail');
    }

    return $response;
  }

  private function resetPassword($key, $reset)
  {
    $user = $this->userGateway->findByEmail($key);
    if ($user && $user['password'] == $reset) {
      ?>
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Change Password</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    margin: 0;
                    padding: 0;
                }
                .container {
                    max-width: 400px;
                    margin: 50px auto;
                    padding: 20px;
                    background-color: #fff;
                    border-radius: 8px;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                }
                h2 {
                    text-align: center;
                }
                form {
                    margin-top: 20px;
                }
                .form-group {
                    margin-bottom: 20px;
                }
                label {
                    display: block;
                    margin-bottom: 5px;
                }
                input[type="password"] {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ccc;
                    border-radius: 5px;
                }
                input[type="submit"] {
                    width: 100%;
                    padding: 10px 0;
                    border: none;
                    border-radius: 5px;
                    background-color: #007bff;
                    color: #fff;
                    cursor: pointer;
                }
                input[type="submit"]:hover {
                    background-color: #0056b3;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h2>Thay đổi mật khẩu</h2>
                <form id="changePasswordForm" method="POST" action="submit-new-password" onsubmit="return validatePassword()">
                    <div class="form-group">
                        <label for="password">Nhập mật khẩu mới</label>
                        <input type="password" name="password" id="password" required>
                    </div>
                    <div class="form-group">
                        <label for="confirm_password">Nhập lại mật khẩu mới</label>
                        <input type="password" name="confirm_password" id="confirm_password" required>
                        <span id="passwordError" style="color: red; display: none;">Mật khẩu nhập lại không khớp!</span>
                    </div>
                    <input type="hidden" name="key" value="<?php echo $key; ?>">
                    <input type="hidden" name="reset" value="<?php echo $reset; ?>">
                    <input type="submit" name="submit_password" value="Thay đổi mật khẩu">
                </form>
            </div>

            <script>
                function validatePassword() {
                    var newPassword = document.getElementById("password").value;
                    var confirmPassword = document.getElementById("confirm_password").value;

                    if (newPassword != confirmPassword) {
                        document.getElementById("passwordError").style.display = "inline";
                        return false;
                    } else {
                        document.getElementById("passwordError").style.display = "none";
                        return true;
                    }
                }
            </script>
        </body>
        </html>
        <?php
    }
    else {
      return Utils::forbiddenResponse("Forbidden");
    } 
  }

}