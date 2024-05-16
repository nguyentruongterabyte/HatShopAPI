<?php
namespace Src\TableGateways;

use Src\Utils\Utils;

class OrderGateway {
  private $db = null;

  public function __construct($db)
  {
    $this->db = $db;
  }

  /**
   * get order where orderId (maDonHang) = $id
   * @param int $id
   * @return object
   */
  public function find($id) {
    $statement = "SELECT * FROM `donhang` WHERE `maDonHang` = :maDonHang";
  
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('maDonHang' => $id));
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
   * Create order
   * @param array $input
   * @return int
   */
  public function create(array $input)
  {
    $statement = "INSERT INTO 
                  `donhang`
                  ( `userId`, `diaChi`, `soLuong`, `tongTien`, `soDienThoai`, `email`) 
                  VALUES (:userId, :diaChi, :soLuong, :tongTien, :sdt, :email)";
  
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
        'userId' => $input['userId'],
        'diaChi' => $input['diaChi'],
        'soLuong' => $input['soLuong'],
        'tongTien' => $input['tongTien'],
        'sdt' => $input['sdt'],
        'email' => $input['email'],
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

  /**
   * Select max order id of user has userId = $userId
   * @param int $userId
   * @return int
   */
  public function maxId($userId) {
    $statement = "SELECT maDonHang FROM `donhang` WHERE `userId` = :userId ORDER BY maDonHang DESC LIMIT 1";
  
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('userId' => $userId));
      $result = $statement->fetch(\PDO::FETCH_ASSOC);
      return $result['maDonHang'];
    } catch (\PDOException $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }

  /**
   * get all orders by userId
   * @param int $userId
   * @return array
   */
  public function getByUserId($userId) {
    $statement = "SELECT * FROM v_orders WHERE `userId` = :userId ORDER BY maDonHang DESC";
  
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('userId' => $userId));
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


  /**
   * get all order
   * @return array
   */
  public function getAll() {
    $statement = "SELECT * FROM v_orders WHERE 1 ORDER BY maDonHang DESC";
  
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

  /**
   * Delete order by order id
   * @param int $id
   * @return int
   */
  public function delete($id) {
    $statement = "DELETE FROM `donhang` WHERE `maDonHang` = :maDonHang";

    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('maDonHang' => $id));
      $result = $statement->rowCount();
      return $result;
    } catch (\PDOException $e) {
      exit($e -> getMessage());
    } 
  }


  /**
   * update status of order where orderId (maDonHang) = $orderId
   * @param int $orderId
   * @param string $status
   * @return int
   */
  public function updateStatus($orderId, $status) {
    $statement = "UPDATE donhang 
                  SET trangThai = :trangThai 
                  WHERE maDonHang = :maDonHang
                  ";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
        'maDonHang' => $orderId,
        'trangThai' => $status ?? null
      ));
      return $statement->rowCount();
    } catch (\PDOException $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }

  /**
   * Summary of updateToken
   * @param int $orderId
   * @param string $token
   * @return int
   */
  public function updateToken($orderId, $token) {
    $statement = "UPDATE donhang 
                  SET token = :token 
                  WHERE maDonHang = :maDonHang
                  ";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
        'maDonHang' => $orderId,
        'token' => $token ?? null
      ));
      return $statement->rowCount();
    } catch (\PDOException $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }

   /**
   * Cancel order
   * @param int $orderId
   * @return int
   */
  public function cancelOrder ($orderId) {
    $statement = 'call databannon.SP_CANCEL_ORDER(:orderId)';

    try {
      $statement = $this->db->prepare($statement);
      $statement->bindParam(":orderId", $orderId, \PDO::PARAM_INT);
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
}