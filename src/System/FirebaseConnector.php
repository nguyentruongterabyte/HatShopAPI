<?php
namespace Src\System;

require '../vendor/autoload.php';
use Kreait\Firebase\Factory;
use Src\Utils\Utils;

class FirebaseConnector {
  private $factory = null;
  private $serviceAccountPath = '../serviceAccountKey.json';

  public function __construct() {
    try {
      $this->factory = (new Factory) -> withServiceAccount($this->serviceAccountPath);
    } catch (\Exception $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }

  public function getFactory() {
    return $this->factory;
  }

}