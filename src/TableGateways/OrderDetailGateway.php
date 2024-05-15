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
      exit($e -> getMessage());
    }
  }

  /**
   * Create many order detail with json send to database
   * @param array $input
   * @return int
   */
  public function createOrderDetails(array $input)
  {
    // code
  }


}