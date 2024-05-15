<?php
namespace Src\TableGateways;

use Src\Utils\Utils;

class CategoryGateway {
  private $db = null;

  public function __construct($db) {
    $this->db = $db;
  }

  public function getAll() {
    $statement = "SELECT * FROM `danhmuc`";
    
    try {
      $statement = $this->db->query($statement);
      $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
      return $result;
    } catch (\PDOException $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }
}