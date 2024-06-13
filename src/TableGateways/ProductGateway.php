<?php
namespace Src\TableGateways;

use Src\TableGateways\AbstractTableGateways;
use Src\Utils\Utils;

class ProductGateway extends AbstractTableGateways{
  private $db = null;

  public function __construct($db) {
    $this->db = $db;
  }

  
  /**
   * Get product by page and amount
   * @param int $page
   * @param int $amount
   * @return array: array includes objects 
   * (  maSanPham, 
   *    tenSanPham,
   *    soLuong, 
   *    gioiTinh, 
   *    mauSac, 
   *    hinhAnh, 
   *    trangThai, 
   *    giaSanPham, 
   *    daBan
   * )
   */
  public function getPage($page, $amount) {
    $statement = "call SP_GET_PRODUCTS_PAGE(:page, :amount)";
    try {
      $statement = $this->db->prepare($statement);
      $statement->bindParam(":page", $page, \PDO::PARAM_INT);
      $statement->bindParam(":amount", $amount, \PDO::PARAM_INT);
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

  /**
   * get featured products
   * @param int $amount
   * @return array: array includes objects 
   * (  maSanPham, 
   *    tenSanPham,
   *    soLuong, 
   *    gioiTinh, 
   *    mauSac, 
   *    hinhAnh, 
   *    trangThai, 
   *    giaSanPham, 
   *    daBan
   * )
   */
  public function getFeatured($amount) {
    $statement = "call SP_GET_FEATURED_PRODUCTS (:amount)";
    try {
      $statement = $this->db->prepare($statement);
      $statement->bindParam(":amount", $amount, \PDO::PARAM_INT);
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

  /**
   * Insert new product
   * @param array $input
   * @return int
   */
  public function create(Array $input) {
    $statement = "INSERT INTO sanpham (tenSanPham, soLuong, gioiTinh, mauSac, hinhAnh, giaSanPham, moTa) 
                  VALUES (:tenSanPham, :soLuong, :gioiTinh, :mauSac, :hinhAnh, :giaSanPham, :moTa)
                 ";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
        'tenSanPham' => $input['tenSanPham'] ?? null,
        'soLuong' => $input['soLuong'] ?? 10,
        'gioiTinh' => $input['gioiTinh'] ?? 'Nam',
        'mauSac' => $input['mauSac'] ?? 'Đen',
        'hinhAnh' => $input['hinhAnh'] ?? '',
        'giaSanPham'=> $input['giaSanPham'] ?? '100000',
        'moTa' => $input['moTa'] ?? ''
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
   * Update product
   * @param array $input
   * @return int
   */
  public function update(Array $input) {
    $statement = "UPDATE sanpham 
                  SET tenSanPham = :tenSanPham, 
                      soLuong = :soLuong, 
                      gioiTinh = :gioiTinh, 
                      mauSac = :mauSac, 
                      hinhAnh = :hinhAnh, 
                      giaSanPham = :giaSanPham,
                      moTa = :moTa
                  WHERE maSanPham = :maSanPham
                  ";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
        'maSanPham' => (int) $input['maSanPham'] ?? null,
        'tenSanPham' => $input['tenSanPham'] ?? null,
        'soLuong' => $input['soLuong'] ?? 10,
        'gioiTinh' => $input['gioiTinh'] ?? 'Nam',
        'mauSac' => $input['mauSac'] ?? null,
        'hinhAnh' => $input['hinhAnh'] ?? null,
        'giaSanPham'=> $input['giaSanPham'] ?? null,
        'moTa' => $input['moTa'] ?? ''
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
   * get product by id refer to maSanPham
   * @param int $id
   * @return object
   */
  public function find($id) {
    $statement = "SELECT * FROM `sanpham` WHERE `maSanPham` = :maSanPham";
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
   * Get total product
   * @return int
   */
  public function getQuantity (){
    $statement = "SELECT COUNT(maSanPham) as total from `sanpham` WHERE soLuong > 0";

    try {
      $statement = $this->db->prepare($statement);
      $statement->execute();
      $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
      if (!empty($result)) {
        return (int)$result[0]['total'];
      }
      return 0;
    } catch (\PDOException $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }    
  }

  /**
   * Search product by key
   * @param string $key
   * @return array
   */
  public function search($key) {
    $statement = "SELECT * FROM `sanpham` WHERE `tenSanPham` LIKE :keySearch";
    try {
        $statement = $this->db->prepare($statement);
        $statement->execute(array('keySearch' => "%$key%"));
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