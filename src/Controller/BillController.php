<?php
namespace Src\Controller;

use Src\TableGateways\OrderDetailGateway;
use Src\TableGateways\OrderGateway;
use Src\Utils\Utils;

class BillController {
  private $db;
  private $requestMethod;
  private $orderGateway;
  private $orderDetailGateway;
  private $orderId;

  public function __construct($db, $requestMethod, $orderId)
  {
    $this->db = $db;
    $this->requestMethod = $requestMethod;
    $this->orderId = $orderId;
    $this->orderGateway = new OrderGateway($this->db);
    $this->orderDetailGateway = new OrderDetailGateway($this->db);
  }

  public function processRequest() {
    switch ($this->requestMethod) {
      case 'GET':
        $response = $this->get($this->orderId);
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

  private function get($orderId) {
    $order = $this->orderGateway->find($orderId);
    if (!$order) {
      return Utils::notFoundResponse('Không tìm thấy hóa đơn');
    }
    $order['items'] = $this->orderDetailGateway->getByOrderId($orderId);

    $response = Utils::successResponse('Thành công');
    $response['body']['result'] = $order;
    return $response;

  }
}