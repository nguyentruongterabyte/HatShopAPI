<?php
namespace Src\TableGateways;

class ProductGateway {
  private $db = null;

  public function __construct($db) {
    $this->db = $db;
  }

  
  /**
   * Get product by page and amount
   * @param int $page
   * @param int $amount
   * @return array
   */
  public function getPage($page, $amount) {
    $pos = ($page - 1) * $amount;
    $statement 
    =    "SELECT sp.*, COALESCE(SUM(ct.soLuong), 0) 
          AS daBan
					FROM `sanpham` sp
					LEFT JOIN `chitietdonhang` ct ON sp.maSanPham = ct.maSanPham
					WHERE sp.soLuong > 0
					GROUP BY sp.maSanPham
					ORDER BY sp.maSanPham DESC 
					LIMIT $pos, $amount
        ";
    try {
    
      $statement = $this->db->query($statement);
      $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
      return $result;
    } catch (\PDOException $e) {
      exit($e->getMessage());
    }
  }

  /**
   * get featured products
   * @param int $amount
   * @return array
   */
  public function getFeatured($amount) {
    $statement = "SELECT sp.*, COALESCE(SUM(ct.soLuong), 0) AS daBan
					FROM `sanpham` sp
					LEFT JOIN `chitietdonhang` ct ON sp.maSanPham = ct.maSanPham
					WHERE sp.soLuong > 0
					GROUP BY sp.maSanPham
					ORDER BY sp.maSanPham 
					DESC LIMIT $amount";
    try {
      $statement = $this->db->query($statement);
      $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
      return $result;
    } catch(\PDOException $e) {
      exit($e->getMessage());
    }
  }

  /**
   * Insert new product
   * @param array $input
   * @return int
   */
  public function insert(Array $input) {
    $statement = "INSERT INTO sanpham (tenSanPham, soLuong, gioiTinh, mauSac, hinhAnh, giaSanPham) 
                  VALUES (:tenSanPham, :soLuong, :gioiTinh, :mauSac, :hinhAnh, :giaSanPham)
                 ";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
        'tenSanPham' => $input['tenSanPham'] ?? null,
        'soLuong' => $input['soLuong'] ?? null,
        'gioiTinh' => $input['gioiTinh'] ?? null,
        'mauSac' => $input['mauSac'] ?? null,
        'hinhAnh' => $input['hinhAnh'] ?? null,
        'giaSanPham'=> $input['giaSanPham'] ?? null
      ));
      return $statement->rowCount();
    } catch (\PDOException $e) {
      exit($e->getMessage());
    }
  }

  /**
   * get product by id refer to maSanPham
   * @param int $id
   * @return object
   */
  public function find($id) {
    $statement = "SELECT * FROM `sanpham` WHERE `maSanPham` = :maSanPham";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('maSanPham' => $id));
      $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
      return $result[0];
    } catch (\PDOException $e) {
      exit($e -> getMessage());
    }
  }

  

  public function search($key) {
    $statement = "SELECT * FROM `sanpham` WHERE `tenSanPham` LIKE :keySearch";
    try {
        $statement = $this->db->prepare($statement);
        $statement->execute(array('keySearch' => "%$key%")); // Include the % symbols here
        $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
        return $result;
    } catch (\PDOException $e) {
        exit($e->getMessage());
    }
}

  /**
   * Delete by id refer maSanPham 
   * @param int $id 
   * @return int
   */
  public function delete($id) {
    $statement = "DELETE FROM `sanpham` WHERE `maSanPham` = :maSanPham";

    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('maSanPham' => $id));
      $result = $statement->rowCount();
      return $result;
    } catch (\PDOException $e) {
      exit($e -> getMessage());
    } 
  }
}