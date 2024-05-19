<?php
namespace Src\TableGateways;

use Src\Utils\Utils;

class ImageFactory
{
  private $factory = null;
  private $storage;
  private $storageBucket;
  protected static $timeFileContain = '+10 year';

  public function __construct($factory)
  {
    $this->factory = $factory;
    $this->storage = $this->factory->createStorage();
    $this->storageBucket = $this->storage->getBucket();
  }
  /**
   * Upload image to fire
   * @param mixed $file
   * @return string: return image download url
   */
  public function upload($file) {

    try {
      // Create unique name
      $filename = uniqid() . '.jpg';
      $object = $this->storageBucket->upload(
        file_get_contents($file['file']['tmp_name']),
        [
          'name' => $filename,
        ]
      );

      $downloadURL = $object->signedUrl(new \DateTime(self::$timeFileContain));
      return $downloadURL;
    } catch (\Exception $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }

  /**
   * delete object on firebase base on imageURL
   * @param string $imageURL
   * @return void
   */
  public function delete($imageURL) {
    try {

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
      $object = $this->storageBucket->object($objectName);

      // Kiểm tra ảnh nếu có tồn tại trên firebase không
      // Nếu có thì thực hiện xóa khỏi firebase
      if ($object->exists()) {
        $object->delete();
      }
    } catch(\Exception $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }
}