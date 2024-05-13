<?php
namespace Src\Controller;

use Src\TableGateways\ProductGateway;

class ProductController {
  private $db;
  private $requestMethod;

  private $productGateway;
  private $page;
  private $amount;
  private $id;
  private $key;

  public function __construct($db, $requestMethod, $page, $amount, $id, $key) {
    $this->db = $db;
    $this->requestMethod = $requestMethod;
    $this->page = $page;
    $this->amount = $amount;
    $this->id = $id;
    $this->key = $key;
    $this->productGateway = new ProductGateway($db);
  }

  public function processRequest() {
    switch ($this->requestMethod) {
      case 'GET':
        if ($this->id) {
          $response = $this->getById($this->id);
        } else if ($this->page && $this->amount) {
          $response = $this->getPage();
        } else if ($this->amount) {
          $response = $this->getFeatured();
        } else if ($this->key) {
          $response = $this->searchProducts($this->key);
        }
        break;
      case 'POST':
        $response = $this->createProductFromRequest();
        break;
      case 'DELETE':
        $response = $this->delete();
        break;
      default:
        $response = $this->notFoundResponse();
        break;
    }

    header($response['status_code_header']);
    if ($response['body']) {
      header('Content-Type: application/json');
      echo json_encode($response['body']);
    }
  }

  private function searchProducts($key) {
    $result = $this->productGateway->search($key);
    $response['status_code_header'] = 'HTTP/1.1 200 OK';
    $response['body'] = [
      'status' => 200,
      'message' => 'Thành công',
      'result' => $result
    ];
    return $response;
  }

  private function getById($id) {
    $result = $this->productGateway->find($id);
    if (!$result) {
      return $this->notFoundResponse();
    }

    $response['status_code_header'] = 'HTTP/1.1 200 OK';
    $response['body'] = [
      'status' => 200,
      'message' => 'Lấy thông tin sản phẩm thành công',
      'result' => $result
    ];
    return $response;
  }



  private function delete() {
    parse_str(file_get_contents("php://input"), $_DELETE);
    $id = $_DELETE['maSanPham'];
    $result = $this->productGateway->find($id);
    if (!$result) {
      return $this->notFoundResponse();
    }

    $this->productGateway->delete($id);
    $response['status_code_header'] = 'HTTP/1.1 200 OK';
    $response['body'] = [
      'status' => 200,
      'message' => 'Xóa sản phẩm thành công'
    ];
    return $response;
  }

  private function getFeatured() {
    $result = $this->productGateway->getFeatured($this->amount);
    $response['status_code_header'] = 'HTTP/1.1 200 OK';

    $response['body'] = [
      'status' => 200,
      'message' => 'Thành công',
      'result' => $result
    ];
    return $response;
  }

  private function getPage() {
    $result = $this->productGateway->getPage($this->page, $this->amount);
    $response['status_code_header'] = 'HTTP/1.1 200 OK';

    $response['body'] = [
      'status' => 200,
      'message' => 'Thành công',
      'result' => $result
    ];
    return $response;
  }

  private function createProductFromRequest() {
    $input = $_POST;
    if (!$this->validateProduct($input)) {
      return $this->unprocessableEntityResponse();
    }

    $this->productGateway->insert($input);
    $response['status_code_header'] = 'HTTP/1.1 201 Created';
    $response['body'] = [
      'status' => 200,
      'message' => 'Thêm sản phẩm mới thành công'
    ];
    return $response;
  }

  private function notFoundResponse() {
    $response['status_code_header'] = 'HTTP/1.1 404 Not Found';
    $response['body'] = [
      'status' => 404,
      'message' => 'Không tìm thấy sản phẩm'
    ];

    return $response;
  }

  private function validateProduct($input) {
    if (
      !isset($input['tenSanPham']) 
    || !isset($input['soLuong']) 
    || !isset($input['gioiTinh'])
    || !isset($input['mauSac'])
    || !isset($input['hinhAnh'])
    || !isset($input['giaSanPham'])
  ) {
      return false;
  }

    return true;
  }

  private function unprocessableEntityResponse() {
    $response['status_code_header'] = 'HTTP/1.1 422 Unprocessable Entity';
    $response['body'] = [
      'status'=> 422,
      'message' => 'Đầu vào không hợp lệ',
    ];
    return $response;
  }
}