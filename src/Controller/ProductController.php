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
  private $factory;
  private $isUploadImage;

  public function __construct($db, $requestMethod, $page, $amount, $id, $key, $factory, $isUploadImage) {
    $this->db = $db;
    $this->requestMethod = $requestMethod;
    $this->page = $page;
    $this->amount = $amount;
    $this->id = $id;
    $this->key = $key;
    $this->factory = $factory;
    $this->isUploadImage = $isUploadImage;
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
        } else {
          $response = $this->getQuantity();
        }
        break;
      case 'POST':
        if ($this->isUploadImage) {
          $response = $this->postImage();
        } else {
          $response = $this->createProduct();
        }
        break;
      case 'PUT':
        $response = $this->upDateProduct();
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

  private function updateProduct() {
    parse_str(file_get_contents("php://input"), $_PUT);
    $input = $_PUT;

    if (!isset($input["maSanPham"])) {
      return $this->unprocessableEntityResponse();
    }
    $product = $this->productGateway->find($input["maSanPham"]);
    if (empty(get_object_vars((object)$product))) {
      return $this->notFoundResponse();
    }
    
    if (!$this->validateProduct($input)) {
      return $this->unprocessableEntityResponse();
    }
    $this->productGateway->update($input);
    $response['status_code_header'] = 'HTTP/1.1 200 OK';
    $response['body'] = [
      'status' => 200,
      'message' => 'Cập nhật dữ liệu thành công'
    ];
    return $response;
  }

  private function postImage() {
    $input = $_POST;
    $id = isset($input['maSanPham']) ? $input['maSanPham'] : -1;
    $product = (object)[];
    $storage = $this->factory->createStorage();
    $storageBucket = $storage->getBucket();

    if ($id != -1) {
      $product = $this->productGateway->find($id);
      if (empty(get_object_vars((object)$product))) {
        return $this->notFoundResponse();
      } else {
        // Xóa hình ảnh sản phẩm trên firebase
        $imageURL = $product['hinhAnh'];
        // tách path thành object gồm
        //"scheme":"https",
        //"host":"...",
        //"path":"\/v0\/b\/hatshop-75393.appspot.com\/o\/663857bbe4a8e.jpg"
        //"query":"..."}
        $urlParts = parse_url($imageURL);
        
        // Lấy phần tử path trong urlParts
        $pathParts = explode('/', $urlParts['path']);

        // Lấy phần cuối của đường link
        $objectName = urldecode(end($pathParts));
        $object = $storageBucket->object($objectName);

        // Kiểm tra ảnh nếu có tồn tại trên firebase không
        // Nếu có thì thực hiện xóa khỏi firebase
        if ($object->exists()) {
          $object->delete();
        }
      } 
    }

    // Tải hình ảnh mới lên firebase
    if (isset($_FILES['file'])) {
      // Tạo ra một tên duy nhất cho file đê upload lên firebase
      $filename = uniqid() . '.jpg';

      $object = $storageBucket->upload(
        file_get_contents($_FILES['file']['tmp_name']),
        [
          'name' => $filename
        ]
      );

      // Lấy đường link của hình ảnh
      $downloadURL = $object->signedUrl(new \DateTime('+10 year'));

    } else {
      return $this->unprocessableEntityResponse();
    }

    $response['status_code_header'] = 'HTTP/1.1 200 OK';
    $response['body'] = [
      'status' => 200,
      'message' => "Thành công",
      'result' => $downloadURL
    ];
    return $response;
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
    if (empty(get_object_vars((object)$result))) {
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
    if (empty(get_object_vars((object)$result))) {
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

  private function createProduct() {
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

  private function getQuantity() {
    $result = $this->productGateway->getQuantity();
    $response['status_code_header'] = 'HTTP/1.1 200 OK';

    $response['body'] = [
      'status' => 200,
      'message' => 'Lấy số lượng thành sản phẩm công',
      'result' => $result
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