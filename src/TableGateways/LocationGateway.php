<?php
namespace Src\TableGateways;

use Src\Utils\Utils;

class LocationGateway {
  private $db = null;

  public function __construct($db) {
    $this->db = $db;
  }

  /**
   * get last location
   * @return object
   */
  public function get() {
    $statement = "SELECT * FROM `toado` ORDER BY id DESC LIMIT 1";
    
    try {
      $statement = $this->db->query($statement);
      $result = $statement->fetch(\PDO::FETCH_ASSOC);
      return $result;
    } catch (\PDOException $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }

  /**
   * Create a new location of the shop
   * @param array $input
   * @return int
   */
  public function create(Array $input) {
    $statement = "INSERT INTO `toado` (tenViTri, kinhDo, viDo) VALUES (:tenViTri, :kinhDo, :viDo)";
  
    try {
      $statement = $this->db->prepare($statement);

      $statement->execute(
        array(
          'tenViTri' => $input['tenViTri'] ?? 'Hat shop',
          'kinhDo' => $input['kinhDo'] ?? 10.84897,
          'viDo' => $input['viDo'] ?? 10.84897,
        )
      );

      $result = $statement->rowCount();
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