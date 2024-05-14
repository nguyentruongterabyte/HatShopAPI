<?php
namespace Src\TableGateways;
class CartGateway {
  private $db = null;

  public function __construct($db) {
    $this->db = $db;
  }

   /**
   * Insert new cart
   * @param array $input
   * @return int
   */
  public function create(Array $input) {
    $statement = "INSERT INTO `giohang` (`userId`,`maSanPham`, `soLuong`) 
                  VALUES (:userId, :maSanPham, :soLuong)
                 ";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
        'userId'=> $input['userId'],
        'maSanPham'=> $input['maSanPham'],
        'soLuong' => $input['soLuong'] ?? null,
      ));
      return $statement->rowCount();
    } catch (\PDOException $e) {
      exit($e->getMessage());
    }
  }

  
  /**
   * Delete by userId, productId refer maSanPham 
   * @param int $userId
   * @param int $productId 
   * @return int
   */
  public function delete($userId, $productId) {
    $statement = "DELETE FROM `giohang` 
                  WHERE `userId` = :userId 
                  AND `maSanPham` = :maSanPham
                  ";
  
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
        'maSanPham' => $productId,
        'userId' => $userId
      ));
      $result = $statement->rowCount();
      return $result;
    } catch (\PDOException $e) {
      exit($e -> getMessage());
    } 
  }

  /**
   * Get all product in cart by user id
   * @param int $userId
   * @return array
   */
  public function getAll($userId) {
    $statement = "SELECT gh.`maSanPham`, `userId`, 
                         sp.`tenSanPham`, 
                         sp.`giaSanPham` * gh.`soLuong` AS giaSanPham, 
                         sp.`hinhAnh`, gh.`soLuong`, 
                         sp.`soLuong` AS soLuongToiDa 
                  FROM `giohang` gh
                  INNER JOIN `sanpham` sp 
                  ON userId = $userId 
                  AND gh.maSanPham = sp.maSanPham";
    try {
      $statement = $this->db->query($statement);
      $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
      return $result;
    } catch(\PDOException $e) {
      exit($e->getMessage());
    }
  }

  /**
   * update quantity, cost in cart
   * @param array $input
   * @return int
   */
  public function update(Array $input) {
    $statement = 
      "UPDATE `giohang` 
      SET `soLuong` = :soLuong 
      WHERE `userId` = :userId AND `maSanPham` = :maSanPham";

      try {
        $statement = $this->db->prepare($statement);
        $statement->execute(array(
          'soLuong' => $input['soLuong'] ?? null,
          'userId' => $input['userId'] ?? null,
          'maSanPham' => $input['maSanPham'] ?? null
        ));
        return $statement->rowCount();
    } catch (\PDOException $e) {
      exit($e->getMessage());
    }
  }

  /**
   * find cart where productId (maSanPham) = $id
   * @param int $id
   * @return object
   */
  public function find($id) {
    $statement = "SELECT * FROM `giohang` WHERE `maSanPham` = :maSanPham";

    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('maSanPham' => $id));
      $result = $statement->fetch(\PDO::FETCH_ASSOC);
      return $result;
    } catch (\PDOException $e) {
      exit($e -> getMessage());
    }
  }

  private function find2($productId, $userId) {
    $statement = "SELECT * FROM `giohang` WHERE `userId` = :userId AND `maSanPham` = :maSanPham";

    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
        'maSanPham' => $productId,
        'userId' => $userId
      ));
      $result = $statement->fetch(\PDO::FETCH_ASSOC);
      return $result;
    } catch (\PDOException $e) {
      exit($e -> getMessage());
    }
  }
}
