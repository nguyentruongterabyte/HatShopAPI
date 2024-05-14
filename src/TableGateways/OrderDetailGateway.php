<?php
namespace Src\TableGateways;

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
      exit($e -> getMessage());
    }
  }

}