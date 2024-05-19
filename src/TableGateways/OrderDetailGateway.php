<?php
namespace Src\TableGateways;

use Src\Utils\Utils;

class OrderDetailGateway {
  private $db = null;

  public function __construct($db)
  {
    $this->db = $db;
  }

  /**
   * get order detail where productId (maSanPham) = $id
   * @param int $id
   * @return object
   */
  public function find($id) {
    $statement = "SELECT * FROM `chitietdonhang` WHERE `maSanPham` = :maSanPham";
  
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('maSanPham' => $id));
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
   * Create many order details from json
   * @param int $orderId
   * @param string $input
   * @return int
   */
  public function createOrderDetails($orderId, $input)
  {
    $statement = "call SP_CREATE_ORDER_DETAILS (:orderId, :json)";
    try {
      $statement = $this->db->prepare($statement);
      $statement->bindParam(":orderId", $orderId, \PDO::PARAM_INT);
      $statement->bindParam(":json", $input, \PDO::PARAM_STR);
      $statement->execute();
      $result = $statement->rowCount();
      return $result;
    } catch(\PDOException $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }

  public function getByOrderId($orderId) {
    $statement = "call SP_GET_PRODUCTS_IN_A_ORDER (:orderId)";
    try {
      $statement = $this->db->prepare($statement);
      $statement->bindParam(":orderId", $orderId, \PDO::PARAM_INT);
      $statement->execute();
      $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
      return $result;
    } catch(\PDOException $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }
}