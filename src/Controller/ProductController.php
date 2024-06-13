<?php
namespace Src\Controller;

use Src\TableGateways\CartGateway;
use Src\TableGateways\ImageFactory;
use Src\TableGateways\ProductGateway;
use Src\TableGateways\OrderDetailGateway;
use Src\TableGateways\RatingGateway;
use Src\TableGateways\RatingImagesGateway;
use Src\Utils\Utils;

class ProductController {
  private $db;
  private $requestMethod;

  private $productGateway;
  private $orderDetailGateway;
  private $ratingGateway;
  private $ratingImagesGateway;
  private $cartGateway;
  private $page;
  private $amount;
  private $id;
  private $key;
  private $factory;
  private $isUploadImage;
  private $imageFactory;

  public function __construct($db, $requestMethod, $page, $amount, $id, $key, $factory, $isUploadImage) {
    $this->db = $db;
    $this->requestMethod = $requestMethod;
    $this->page = $page;
    $this->amount = $amount;
    $this->id = $id;
    $this->key = $key;
    $this->factory = $factory;
    $this->imageFactory = new ImageFactory($factory);
    $this->isUploadImage = $isUploadImage;
    $this->productGateway = new ProductGateway($db);
    $this->orderDetailGateway = new OrderDetailGateway($db);
    $this->ratingGateway = new RatingGateway($db);
    $this->ratingImagesGateway = new RatingImagesGateway($db);
    $this->cartGateway = new CartGateway($db);
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
        $response = Utils::notFoundResponse("Phương thức không hợp lệ!");
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
      return Utils::unprocessableEntityResponse("Chưa cung cấp mã sản phẩm");
    }
    $product = $this->productGateway->find($input["maSanPham"]);  
    if (!$product) {
      return Utils::notFoundResponse('Không có thông tin sản phẩm');
      // return $this->notFoundResponse();
    }
   
    if (!$this->validateProduct($input)) {
      return Utils::unprocessableEntityResponse("Đầu vào không hợp lệ");
    }
    $this->productGateway->update($input);
    $response = Utils::successResponse('Cập nhật dữ liệu thành công');
    return $response;
  }

  private function postImage() {
    $input = $_POST;
    $id = isset($input['maSanPham']) ? $input['maSanPham'] : -1;
    $product = (object)[];

    if ($id != -1) {
      $product = $this->productGateway->find($id);
      if (!$product) {
        return Utils::notFoundResponse("Không có thông tin sản phẩm");
      } else {
        // Xóa hình ảnh sản phẩm trên firebase
        $imageURL = $product['hinhAnh'];

        $this->imageFactory->delete($imageURL);
      }
    }
    // Tải hình ảnh mới lên firebase
    if (isset($_FILES['file']) && $_FILES['file']['tmp_name']) {

      // get image url
      $downloadURL = $this->imageFactory->upload($_FILES);

    } else {
      return Utils::unprocessableEntityResponse("Chưa cung cấp file");
    }

    $response = Utils::successResponse('Thành công');
    $response['body']['result'] = $downloadURL;
    return $response;
  }


  private function searchProducts($key) {
    $result = $this->productGateway->search($key);
    $response = Utils::successResponse('Thành công');
    $response['body']['result'] = $result;
    return $response;
  }

  private function getById($id) {
    $result = $this->productGateway->find($id);
    if (!$result) {
      return Utils::notFoundResponse("Không có thông tin sản phẩm");
    }

    $response = Utils::successResponse("Lấy thông tin sản phẩm thành công");
    $response['body']['result'] = $result;
    // Lấy đánh giá của sản phẩm
    $ratingList = $this->ratingGateway->getByProductId($id);
    // Lấy hình ảnh đánh giá cho mỗi sản phẩm
    foreach ($ratingList as $index => $rating) {
      $imageList = $this->ratingImagesGateway->getRatingImages($rating['maDanhGia']);
      $rating['hinhAnhDanhGiaList'] = $imageList;
      $ratingList[$index] = $rating;
    }
    $response['body']['result']['danhGiaSanPham'] = $ratingList;
    return $response;
  }


  private function delete() {
    parse_str(file_get_contents("php://input"), $_DELETE);

    if (!isset($_DELETE["maSanPham"]) || !$_DELETE["maSanPham"]) {
      return Utils::unprocessableEntityResponse("Chưa cung cấp mã sản phẩm");
    }

    $id = $_DELETE['maSanPham'];

    $result = $this->productGateway->find($id);
    if (!$result) {
      return Utils::notFoundResponse("Không có thông tin sản phẩm");
    }

    if ($this->orderDetailGateway->find($id)) {
      return Utils::conflictResponse("Sản phẩm đã có trong đơn mua, không thể xóa");
    }

    if ($this->cartGateway->find($id)) {
      return Utils::conflictResponse("Sản phẩm đã có trong giỏ hàng của khách hàng, không thể xóa");
    }

    // Xóa hình ảnh sản phẩm trên firebase
    $imageURL = $result['hinhAnh'];

    $this->imageFactory->delete($imageURL);

    $rowCount = $this->productGateway->delete($id);
    
    if ($rowCount > 0) {
      return Utils::successResponse("Xóa sản phẩm thành công");
    } else {
      return Utils::badRequestResponse("Không thể xóa sản phẩm");
    }
  }

  private function getFeatured() {
    $result = $this->productGateway->getFeatured($this->amount);
    
    $response = Utils::successResponse("Thành công");
    $response["body"]["result"] = $result;
    return $response;
  }

  private function getPage() {
    $result = $this->productGateway->getPage($this->page, $this->amount);
    
    $response = Utils::successResponse("Thành công");
    $response["body"]["result"] = $result;
    return $response;
  }

  private function createProduct() {
    $input = $_POST;
    $response = $this->validateProduct($input);
    if ($response['body']['status'] != 200) {
      return $response;
    }
    $rowCount = $this->productGateway->create($input);

    if ($rowCount > 0) {
      $response = Utils::successResponse('Thêm mới sản phẩm thành công');
      
    } else {
      $response = Utils::badRequestResponse("Không thể tạo mới sản phẩm");
    }
    return $response;
  }

  private function getQuantity() {
    $result = $this->productGateway->getQuantity();
    
    $response = Utils::successResponse("Lấy số lượng sản phẩm thành công");
    $response['body']['result'] = $result; 
    return $response;
  }


  private function validateProduct($input)
  {

    // Chưa nhập tên sản phẩm
    if (!isset($input['tenSanPham']) || !$input['tenSanPham']) {
      return Utils::unprocessableEntityResponse("Chưa nhập tên sản phẩm");
    }
    // Chưa nhập số lượng
    else if (!isset($input['soLuong']) || !$input['soLuong']) {
      return Utils::unprocessableEntityResponse("Chưa nhập số lượng sản phẩm");
    } 
    // Chưa chọn giới tính
    else if (!isset($input['gioiTinh']) || !$input['gioiTinh']) {
      return Utils::unprocessableEntityResponse("Chưa chọn giới tính");
    } 
    // Chưa nhập màu sắc
    else if (!isset($input['mauSac']) || !$input['mauSac']) {
      return Utils::unprocessableEntityResponse('Chưa nhập màu sắc');
    } 
    // Chưa có hình ảnh
    else if (!isset($input['hinhAnh']) || !$input['hinhAnh']) {
      return Utils::unprocessableEntityResponse('Chưa có hình ảnh');
    }
    // Chưa có giá sản phẩm 
    else if (!isset($input['giaSanPham']) || !$input['giaSanPham']) {
      return Utils::unprocessableEntityResponse('Chưa nhập giá sản phẩm');
    // Pass
    } else {
      return Utils::successResponse("Pass");
    }
  }
}