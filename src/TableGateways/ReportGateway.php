<?php
namespace Src\TableGateways;

use Src\Utils\Utils;

class ReportGateway {
  private $db = null;

  public function __construct($db) {
    $this->db = $db;
  }

  /**
   * Get year revenue from January to December
   * @param int $year
   * @return array
   */
  public function getYearRevenue($year) {
    $statement = "call SP_YEAR_REVENUE(:year)";
    
    try {
      $statement = $this->db->prepare($statement);
      $statement->bindParam(':year', $year, \PDO::PARAM_INT);
      $statement->execute();
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

  public function getMostYearProduct($year) {
    $statement = "call SP_GET_MOST_YEAR_PRODUCTS(:year, 10)";

    try {
      $statement = $this->db->prepare($statement);
      $statement->bindParam(":year", $year, \PDO::PARAM_INT);
      $statement->execute();
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