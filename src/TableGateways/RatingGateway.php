<?php
namespace Src\TableGateways;

use Src\Utils\Utils;

class RatingGateway {
  private $db;
  public function __construct($db)
  {
    $this->db = $db;
  }
  /**
   * Summary of create
   * @param array $input
   * @return int
   */

  /**
   * Create a rating
   * @param array $input
   * @return int
   */
  public function create(Array $input) {
    $statement = "INSERT INTO `danhgia`
                  (`soSao`, `dungVoiMoTa`, `chatLuongSanPham`, `nhanXet`, `maDonHang`)
                  VALUES (:soSao, :dungVoiMoTa, :chatLuongSanPham, :nhanXet, :maDonHang)";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
          'soSao' => $input['soSao'] ?? 5,
          'dungVoiMoTa' => $input['dungVoiMoTa'] ?? "",
          'chatLuongSanPham' => $input['chatLuongSanPham'] ?? "",
          'nhanXet' => $input['nhanXet'] ?? "",
          'maDonHang' => $input['maDonHang'],
          ));
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
   * 
   * Get rating by orderId
   * @param int $orderId
   * @return object
   */
  public function findByOrderId($orderId) {
    $statement = "SELECT * FROM `danhgia`
                  WHERE `maDonHang` = :maDonHang";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('maDonHang' => $orderId));
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
  public function maxId($orderId) {
    $statement = "SELECT maDanhGia 
                  FROM `danhgia` 
                  WHERE `maDonHang` = :maDonHang
                  ORDER BY maDanhGia DESC
                  LIMIT 1";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('maDonHang' => $orderId));
      $result = $statement->fetch(\PDO::FETCH_ASSOC);
      return $result['maDanhGia'];
    } catch (\PDOException $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
   
  }

  public function find($ratingId) {
    $statement = "SELECT * FROM `danhgia` WHERE `maDanhGia` = :maDanhGia";
  
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array("maDanhGia"=> $ratingId));
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
   * Delete rating by ratingId (maDanhGia)
   * @param int $id
   * @return int
   */
  public function delete($id) {
    $statement = "DELETE FROM `danhgia` WHERE `maDanhGia` = :maDanhGia";

    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('maDanhGia' => $id));
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


  public function getByProductId($productId)
  {
    $statement = 'call SP_GET_PRODUCT_RATING(:productId)';
    try {
      $statement = $this->db->prepare($statement);
      $statement->bindParam(":productId", $productId, \PDO::PARAM_INT);
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