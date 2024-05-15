<?php
namespace Src\Controller;
use Src\TableGateways\CategoryGateway;
use Src\Utils\Utils;

class CategoriesController {
  private $db;
  private $requestMethod;
  private $categoryGateway;

  public function __construct($db, $requestMethod) {
    $this->db = $db;
    $this->requestMethod = $requestMethod;
    $this->categoryGateway = new CategoryGateway($this->db);
  }

  public function processRequest() {
    switch ($this->requestMethod) {
      case 'GET':
        $response = $this->getAll();
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

  public function getAll()
  {
    $result = $this->categoryGateway->getAll();
    $response = Utils::successResponse('Thành công');
    $response['body']['result'] = $result;
    return $response;
  }
}