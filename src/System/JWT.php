<?php
namespace Src\System;

use Firebase\JWT\JWT as FirebaseJWT;
use Firebase\JWT\Key;

class JWT
{
  private $secretKey;
  public function __construct($secretKey)
  {
    $this->secretKey = $secretKey;
  }

  public function createJWT($userId, $expirationTime = 3600)
  {
    $issuedAt = time();
    $payload = [
      'iat' => $issuedAt,
      'exp' => $issuedAt + $expirationTime,
      'sub' => $userId
    ];

    return FirebaseJWT::encode($payload, $this->secretKey, 'HS256');
  }

  public function createRefreshToken($userId, $expirationTime = 1209600) {
    $issuedAt = time();
    $payload = [
      'iat' => $issuedAt,
      'exp' => $issuedAt + $expirationTime,
      'sub' => $userId,
      'type' => 'refresh' 
    ];

    return FirebaseJWT::encode($payload, $this->secretKey, 'HS256');
  }

  public function validateJWT($token) {
    try {
      return FirebaseJWT::decode($token, new Key($this->secretKey, 'HS256'));
    } catch (\Exception $e) {
      return null;
    }
  }

  public function getBearerToken() {
    $headers = getallheaders();
    if (isset($headers['Authorization'])) {
      $matches = [];
      if (preg_match('/Bearer\s(\S+)/', $headers['Authorization'], $matches)) {
        return $matches[1];
      }
    }
    return null; 
  }

}