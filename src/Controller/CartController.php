<?php
namespace Src\Controller;

use Src\TableGateways\CartGateway;
use Src\TableGateways\ProductGateway;
use Src\TableGateways\UserGateway;
use Src\Utils\Utils;

class CartController {
  private $db;
  private $requestMethod;
  private $productGateway;
  private $cartGateway;
  private $userGateway;
  private $userId;

  public function __construct($db, $requestMethod, $userId) {
    $this->db = $db;
    $this->requestMethod = $requestMethod;
    $this->userId = $userId;
    $this->productGateway = new ProductGateway($this->db);
    $this->cartGateway = new CartGateway($this->db);
    $this->userGateway = new UserGateway($this->db);
  }

  public function processRequest() {
    switch($this->requestMethod) {
      case 'GET':
        $response = $this->getAll($this->userId);
        break;
      case 'POST':
        $response = $this->create();
        break;
      case 'PUT':
        $response = $this->update();
        break;
      case 'DELETE':
        $response = $this->delete();
        break;
      default:
        $response = Utils::notFoundResponse("Phương thức không hợp lệ");
        break;
    }

    header($response['status_code_header']);
    if ($response['body']) {
      header('Content-Type: application/json');
      echo json_encode($response['body']);
    }
  }

  private function create() {
    $input = $_POST;
    $response = $this->validateCart($input);
    if ($response['body']['status'] != 200) {
      return $response;
    }

    $product = $this->productGateway->find($input['maSanPham']);

    if (!$product) {
      return Utils::notFoundResponse('Không tồn tại sản phẩm thêm vào giỏ hàng');
    }

    if ((int) $input['soLuong'] > (int) $product['soLuong']) {
      return Utils::unprocessableEntityResponse('Đừng có mà mở Dev Tools lên nhập số lượng đấy! Chỉ có '. $product['soLuong'] . ' cái trong kho thôi');
    }
    // Nếu số lượng thêm vào lớn hơn số lượng hiện có thì lấy số lượng tối đa của sản phẩm
    $input['soLuong'] = (int)$input['soLuong'] > (int)$product['soLuong'] ? $product['soLuong'] : $input['soLuong'];


    if (!$this->userGateway->find($input['userId'])) {
      return Utils::notFoundResponse('Không tồn tại user');
    }

    $rowCount = $this->cartGateway->create($input);

    if ($rowCount > 0) {
      $response = Utils::successResponse('Thêm mới giỏ hàng thành công');
      
    } else {
      $response = Utils::badRequestResponse("Không thể thêm mới giỏ hàng");
    }
    return $response;
  }

  private function delete() {
    parse_str(file_get_contents("php://input"), $_DELETE);
    
    if (!isset( $_DELETE["maSanPham"])) {
      return Utils::unprocessableEntityResponse("Chưa cung cấp mã sản phẩm");
    }

    if (!isset($_DELETE["userId"])) {
      return Utils::unprocessableEntityResponse("Chưa cung cấp userId");
    }

    $productId = $_DELETE['maSanPham'];
    $userId = $_DELETE['userId'];

    if (!$this->productGateway->find($productId)) {
      return Utils::notFoundResponse("Không tìm thấy sản phẩm có mã sản phẩm là " . $productId);
    }

    if (!$this->userGateway->find($userId)) {
      return Utils::notFoundResponse("Không tìm thấy khách hàng");
    }
    $rowCount = $this->cartGateway->delete($userId, $productId);
    if ($rowCount > 0) {
      $response = Utils::successResponse('Xóa sản phẩm khỏi giỏ hàng thành công');
    } else {
      return Utils::badRequestResponse('Không có sản phẩm trong giỏ hàng');
    }
    return $response;
  }

  private function getAll($userId) {
    if (!$userId) {
      return Utils::unprocessableEntityResponse('Chưa cung cấp userId');
    }

    if (!$this->userGateway->find($userId)) {
      return Utils::notFoundResponse('Không tìm thấy người dùng');
    }

    $result = $this->cartGateway->getAll($userId);

    $response = Utils::successResponse('Thành công');
    $response['body']['result'] = $result;
    return $response;
  }

  private function update() {
    parse_str(file_get_contents('php://input'), $_PUT);
    $input = $_PUT;
    if (!isset($input['maSanPham']) || !$input['maSanPham']) {
      return Utils::unprocessableEntityResponse('Chưa có mã sản phẩm');
    }
    if (!isset($input['soLuong']) || !$input['soLuong']) {
      return Utils::unprocessableEntityResponse('Chưa có số lượng sản phẩm');
    }
    if (!isset($input['userId']) || !$input['userId']) {
      return Utils::unprocessableEntityResponse('Chưa có userId');
    }

    $product = $this->productGateway->find($input['maSanPham']);

    if (!$product) {
      return Utils::notFoundResponse('Không tồn tại sản phẩm thêm vào giỏ hàng');
    }

    // Nếu số lượng thêm vào lớn hơn số lượng hiện có thì lấy số lượng tối đa của sản phẩm
    $input['soLuong'] = (int)$input['soLuong'] > (int)$product['soLuong'] ? $product['soLuong'] : $input['soLuong'];

    if (!$this->userGateway->find($input['userId'])) {
      return Utils::notFoundResponse('Không tồn tại user');
    }

    $rowCount = $this->cartGateway->update($input);
    if ($rowCount > 0) {
      $response = Utils::successResponse('Cập nhật giỏ hàng thành công');
    } else {
      $response = Utils::badRequestResponse('Không có gì thay đổi');
    }

    return $response;

  }

  private function validateCart($input) {
    // Chưa nhập số lượng
    if (!isset($input['soLuong']) || !$input['soLuong']) {
      return Utils::unprocessableEntityResponse("Chưa có số lượng sản phẩm");
    } 
    // Chưa chọn userId
    else if (!isset($input['userId']) || !$input['userId']) {
      return Utils::unprocessableEntityResponse("Chưa có userId");
    } 
    // Chưa nhập màu sắc
    else if (!isset($input['maSanPham']) || !$input['maSanPham']) {
      return Utils::unprocessableEntityResponse('Chưa có mã sản phẩm');
    } else {
      return Utils::successResponse("Pass");
    }
  }

}