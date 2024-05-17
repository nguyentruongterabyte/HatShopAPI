<?php
namespace Src\Controller;
use Src\TableGateways\ReportGateway;
use Src\Utils\Utils;

class ReportController {
  private $db;
  private $requestMethod;
  private $reportGateway;
  private $requestName;
  private $year;

  public function __construct($db, $requestMethod, $requestName, $year) {
    $this->db = $db;
    $this->requestMethod = $requestMethod;
    $this->requestName = $requestName;
    $this->year = $year;
    $this->reportGateway = new ReportGateway($this->db);
  }

  public function processRequest() {
    switch ($this->requestMethod) {
      case "GET":
        if ($this->requestName == 'revenue') {
          $response = $this->getYearRevenue($this->year);
        } else if ($this->requestName == 'products'){
          $response = $this->getMostYearProducts($this->year);
        } else {
          $response = Utils::notFoundResponse('Phương thức không hợp lệ!');
        }
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

  private function getYearRevenue($year) {
    $result = $this->reportGateway->getYearRevenue($year);
    $response = Utils::successResponse('Thành công');
    $response['body']['result'] = $result;
    return $response;
  }

  private function getMostYearProducts($year) {
    $result = $this->reportGateway->getMostYearProduct($year);
    $response = Utils::successResponse('Thành công');
    $response['body']['result'] = $result;
    return $response;
  }
}