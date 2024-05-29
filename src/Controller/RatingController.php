<?php
namespace Src\Controller;
use Src\TableGateways\ImageFactory;
use Src\TableGateways\RatingGateway;
use Src\TableGateways\RatingImagesGateway;
use Src\Utils\Utils;

class RatingController {
  private $db;
  private $requestMethod;
  private $ratingGateway;
  private $ratingImagesGateway;
  private $requestName;
  private $factory;
  private $imageFactory;

  public function __construct($db, $requestMethod, $requestName, $factory) {
    $this->db = $db;
    $this->requestMethod = $requestMethod;
    $this->requestName = $requestName;
    $this->factory = $factory;
    $this->ratingGateway = new RatingGateway($this->db);
    $this->ratingImagesGateway = new RatingImagesGateway($this->db);
    $this->imageFactory = new ImageFactory($this->factory);
  }

  public function processRequest() {
    switch ($this->requestMethod) {
      case 'POST':
        if ($this->requestName == 'upload-image') {
          $response = $this->uploadImage();
        } else if ($this->requestName == 'create') {
          $response = $this->create();
        } else {
          $response = Utils::notFoundResponse('Không tìm thấy request');
        }
        break;
      case 'DELETE':
        $response = $this->delete();
        break;
      default:
        $response = Utils::notFoundResponse('Phương thức không hợp lệ');
        break;
      }
    header($response['status_code_header']);
    if ($response['body']) {
      header('Content-Type: application/json');
      echo json_encode($response['body']);
    }
  }

  private function delete() {
    parse_str(file_get_contents('php://input'), $_DELETE);
    if (!isset($_DELETE['maDanhGia'])) {
      return Utils::unprocessableEntityResponse("Chưa cung cấp mã đánh giá");
    }
    $ratingId = $_DELETE['maDanhGia'];
    if (!$this->ratingGateway->find($ratingId)) {
      return Utils::notFoundResponse("Không tìm thấy đánh giá");
    }

    $rowCount = $this->ratingGateway->delete($ratingId);

    if ($rowCount > 0) {
      $response = Utils::successResponse('Xóa đánh giá hàng thành công');
    } else {
      return Utils::badRequestResponse('Không có sản phẩm trong giỏ hàng');
    }
    return $response;
  }

  private function uploadImage() {
    if (isset($_FILES['file']) && $_FILES['file']['tmp_name']) {
      $downloadURL = $this->imageFactory->upload($_FILES);
    } else {
      return Utils::unprocessableEntityResponse('Chưa cung cấp file');
    }

    $response = Utils::successResponse('Thành công');
    $response['body']['result'] = $downloadURL;
    return $response;
  }

  private function create() {
    $input = $_POST;

    $response = $this->validateRating($input);

    // Not ok
    if ($response['body']['status'] != 200) {
      return $response;
    }

    $rowCount = $this->ratingGateway->create($input);

    if ($rowCount > 0) {
      $maxId = $this->ratingGateway->maxId($input['maDonHang']);
      $hinhAnhDanhGia = $input['hinhAnhDanhGia'] ?? null;
      if (isset($hinhAnhDanhGia) && !empty($hinhAnhDanhGia) && $hinhAnhDanhGia != "[]") {
        $rowCount = $this->ratingImagesGateway->createRatingImages($maxId, $input['hinhAnhDanhGia']);
        if ($rowCount > 0) {
          $response = Utils::successResponse('Tạo đánh giá thành công');
          $response['body']['result'] = $maxId;
        } else {
          $this->ratingGateway->delete($maxId);
          $response = Utils::badRequestResponse('Lỗi khi thêm hình ảnh đánh giá');
        }
      }
    } else {
      return Utils::badRequestResponse('Không thể tạo đánh giá');
    }

    $response = Utils::successResponse('Tạo đánh giá thành công');
    return $response;
  }

  private function validateRating($input) {
    if (!isset($input['maDonHang']) || !$input['maDonHang']) {
      $response = Utils::unprocessableEntityResponse('Chưa cung cấp mã đơn hàng');
    } else if ($this->ratingGateway->findByOrderId($input['maDonHang'])) {
      $response = Utils::conflictResponse('Bạn đã đánh giá trước đó');
    } else {
      $response = Utils::successResponse('Pass');
    }
    return $response;
  }
}