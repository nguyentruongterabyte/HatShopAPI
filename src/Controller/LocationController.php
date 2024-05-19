<?php
namespace Src\Controller;
use Src\TableGateways\LocationGateway;
use Src\Utils\Utils;

class LocationController {
  private $db;
  private $requestMethod;
  private $locationGateway;

  public function __construct($db, $requestMethod) {
    $this->db = $db;
    $this->requestMethod = $requestMethod;
    $this->locationGateway = new locationGateway($this->db);
  }

  public function processRequest() {
    switch ($this->requestMethod) {
      case 'GET':
        $response = $this->get();
        break;
      case 'POST':
        $response = $this->post();
        break;
      default:
        $response = Utils::notFoundResponse('Phương thức không hợp lệ');
        break;
      }
    header($response['status_code_header']);
    if ($response['body']) {
      header('Content-Type: application/json');
      echo json_encode($response['body']);
    }
  }

  public function get()
  {
    $result = $this->locationGateway->get();
    $response = Utils::successResponse('Thành công');
    $response['body']['result'] = $result;
    return $response;
  }

  public function post() {
    if (!isset($_POST['tenViTri']) || !$_POST['tenViTri']) {
      return Utils::unprocessableEntityResponse('Chưa cung cấp tên vị trí');
    } 
    
    if (!isset($_POST['kinhDo']) || !$_POST['kinhDo']) {
      return Utils::unprocessableEntityResponse('Chưa cung cấp tên vị trí');
    }

    if (!isset($_POST['viDo']) || !$_POST['viDo']) {
      return Utils::unprocessableEntityResponse('Chưa cung cấp tên vị trí');
    }


    $rowCount = $this->locationGateway->create($_POST);

    if ($rowCount > 0) {
      $response = Utils::successResponse('Thêm tọa độ thành công');
    } else {
      $response = Utils::badRequestResponse('Không thành công');
    }
    return $response;

  }
}