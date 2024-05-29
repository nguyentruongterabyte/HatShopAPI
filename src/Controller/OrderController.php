<?php
namespace Src\Controller;

use Src\TableGateways\OrderDetailGateway;
use Src\TableGateways\OrderGateway;
use Src\TableGateways\UserGateway;
use Src\Utils\Utils;

class OrderController
{
  private $db;
  private $requestMethod;
  private $requestName;
  private $userId;
  private $orderGateway;
  private $orderDetailGateway;
  private $userGateway;

  public function __construct($db, $requestMethod, $userId, $requestName)
  {
    $this->db = $db;
    $this->requestMethod = $requestMethod;
    $this->userId = $userId;
    $this->requestName = $requestName;
    $this->orderGateway = new OrderGateway($this->db);
    $this->orderDetailGateway = new OrderDetailGateway($this->db);
    $this->userGateway = new UserGateway($this->db);
  }

  public function processRequest()
  {
    switch ($this->requestMethod) {
      case 'GET':
        if ($this->userId) {
          $response = $this->getByUserId($this->userId);
        } else {
          $response = $this->getAll();
        }
        break;
      case 'POST':
        $response = $this->create();
        break;
      case 'PUT':
        switch ($this->requestName) {
          case 'update-status':
            $response = $this->updateStatus();
            break;
          case 'update-token':
            $response = $this->updateToken();
            break;
          case 'cancel':
            $response = $this->cancel();
            break;
          default:
            $response = Utils::forbiddenResponse('Forbidden');
            break;
        }
        break;
      case 'DELETE':
        $response = Utils::notFoundResponse('Chưa có method delete');
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

  private function getByUserId($userId) {
    $result = $this->orderGateway->getByUserId($userId);
    foreach ($result as $index => $order) {
      // Lấy chi tiết đơn hàng
      $items = $this->orderDetailGateway->getByOrderId($order['maDonHang']);

      //
      $result[$index]['items'] = $items;

    }

    unset($order);
    $response = Utils::successResponse('Lấy lịch sử đơn hàng thành công');
    $response['body']['result'] = $result;
    return $response;
  }

  private function getAll() {
    $result = $this->orderGateway->getAll();
    foreach ($result as $index => $order) {
      // Lấy chi tiết đơn hàng
      $items = $this->orderDetailGateway->getByOrderId($order['maDonHang']);

      //
      $result[$index]['items'] = $items;
    }

    unset($order);
    $response = Utils::successResponse('Lấy lịch sử đơn hàng thành công');
    $response['body']['result'] = $result;
    return $response;
  }

  private function create() {
    $input = $_POST;
    $response = $this->validateOrder($input);
    if ($response['body']['status'] != 200) {
      return $response;
    }
    $rowCount = $this->orderGateway->create($input);

    if ($rowCount > 0) {
      $maxId = $this->orderGateway->maxId($input['userId']);
      $rowCount = $this->orderDetailGateway->createOrderDetails($maxId, $input['chiTiet']);
      
      if ($rowCount > 1) {
        $response = Utils::successResponse('Thêm đơn hàng thành công');
        $response['body']['result'] = $maxId;
      } else {
        $this->orderGateway->delete($maxId);
        $response = Utils::badRequestResponse('Lỗi khi thêm chi tiết đơn hàng. Đơn hàng chưa được tạo');
      }

    } else {
      $response = Utils::badRequestResponse("Không thể tạo mới đơn hàng");
    }
    return $response;
  }

  private function updateStatus() {
    parse_str(file_get_contents("php://input"), $_PUT);
    
    if (!isset($_PUT['maDonHang']) || !$_PUT['maDonHang']) {
      return Utils::unprocessableEntityResponse('Chưa cung cấp mã đơn hàng');
    } 

    if (!isset($_PUT['trangThai']) || !$_PUT['trangThai']) {
      return Utils::unprocessableEntityResponse('Chưa cung cấp trạng thái đơn hàng');
    }
    
    $input = $_PUT;
    $order = $this->orderGateway->find($input['maDonHang']);
    if (!$order) {
      return Utils::notFoundResponse('Không tồn tại đơn hàng');
    }

    if (strcmp($order['trangThai'], 'Đã hủy') == 0) {
      return Utils::forbiddenResponse('Đơn hàng đã hủy không thể hủy lần nữa');
    }

    $statusArray = ['Chờ xác nhận', 'Đang giao', 'Đã hủy', 'Đã giao'];

    $statusArrayLower = array_map('strtolower', $statusArray);
    $trangThai = strtolower($input['trangThai']);



    if (!in_array($trangThai, $statusArrayLower)) {
      return Utils::unprocessableEntityResponse("Trạng thái đơn hàng không hợp lệ ('Chờ xác nhận', 'Đang giao', 'Đã hủy', 'Đã giao')");
    }
    $rowCount = $this->orderGateway->updateStatus($input['maDonHang'], $input['trangThai']);
  
    if ($rowCount > 0) {
      return Utils::successResponse('Cập nhật trạng thái đơn hàng thành công');
    } else {
      return Utils::badRequestResponse('Không có gì thay đổi');
    }
  }

  private function updateToken() {
    parse_str(file_get_contents("php://input"), $_PUT);

     if (!isset($_PUT['id']) || !$_PUT['id']) {
      return Utils::unprocessableEntityResponse('Chưa cung cấp mã đơn hàng');
    } 

    if (!isset($_PUT['token']) || !$_PUT['token']) {
      return Utils::unprocessableEntityResponse('Chưa cung cấp token thanh toán');
    }
    
    $input = $_PUT;
    if (!$this->orderGateway->find($input['id'])) {
      return Utils::notFoundResponse('Không tồn tại đơn hàng');
    }

    $rowCount = $this->orderGateway->updateToken($input['id'], $input['token']);
  
    if ($rowCount > 0) {
      return Utils::successResponse('Cập nhật token đơn hàng thành công');
    } else {
      return Utils::badRequestResponse('Không có gì thay đổi');
    }
  }

  private function cancel() {
    parse_str(file_get_contents("php://input"), $_PUT);
    if (!isset($_PUT['maDonHang']) || !$_PUT['maDonHang']) {
      return Utils::unprocessableEntityResponse('Chưa cung cấp mã đơn hàng');
    }

    $orderId = $_PUT['maDonHang'];
    $order = $this->orderGateway->find($orderId);

    if (!$order) {
      return Utils::notFoundResponse('Không tồn tại đơn hàng');
    }

    if (strcmp($order['trangThai'], 'Đã hủy') == 0) {
      return Utils::forbiddenResponse('Đơn hàng đã bị hủy không thể bị hủy thêm lần nữa');
    }

    $rowCount = $this->orderGateway->cancelOrder($orderId);
    if ($rowCount > 0) {
      $response = Utils::successResponse('Hủy đơn hàng thành công');
    } else {
      $response = Utils::badRequestResponse('Lỗi khi hủy đơn hàng');
    }
    return $response;
  }

  private function validateOrder($input)
  {

    // Chưa nhập số điện thoại
    if (!isset($input['sdt']) || !$input['sdt']) {
      return Utils::unprocessableEntityResponse("Chưa có số điện thoại");
    }
    // Chưa nhập có email
    else if (!isset($input['email']) || !$input['email']) {
      return Utils::unprocessableEntityResponse("Chưa có email");
    } 
    // Chưa có tổng tiền
    else if (!isset($input['tongTien']) || !$input['tongTien']) {
      return Utils::unprocessableEntityResponse("Chưa có tổng tiền");
    } 
    // Chưa có địa chỉ
    else if (!isset($input['diaChi']) || !$input['diaChi']) {
      return Utils::unprocessableEntityResponse('Chưa có địa chỉ giao hàng');
    } 
    // Chưa có số lượng sản phẩm trong đơn hàng
    else if (!isset($input['soLuong']) || !$input['soLuong']) {
      return Utils::unprocessableEntityResponse('Chưa có số lượng sản phẩm trong đơn hàng');
    }
    // Chưa có mã khách hàng
    else if (!isset($input['userId']) || !$input['userId']) {
      return Utils::unprocessableEntityResponse('Chưa cung cấp mã khách hàng');
    }
    // khách hàng không tồn tại
    else if (!$this->userGateway->find($input['userId'])) {
      return Utils::notFoundResponse('Mã khách hàng không hợp lệ');
    }
    else {
      // Pass
      return Utils::successResponse("Pass");
    }
  }

}
