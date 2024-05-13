<?php
namespace Src\System;

require '../vendor/autoload.php';
use Kreait\Firebase\Factory;

class FirebaseConnector {
  private $factory = null;
  private $serviceAccountPath = '../serviceAccountKey.json';

  public function __construct() {
    try {
      $this->factory = (new Factory) -> withServiceAccount($this->serviceAccountPath);
    } catch (\Exception $e) {
      exit($e->getMessage());
    }
  }

  public function getFactory() {
    return $this->factory;
  }

}