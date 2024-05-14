<?php
namespace Src\Utils;

class Utils {

  protected static $notFoundHeader = 'HTTP/1.1 404 Not Found';
  protected static $unprocessableEntityHeader = 'HTTP/1.1 422 Unprocessable Entity';
  protected static $badRequestHeader = 'HTTP/1.1 400 Bad Request';
  protected static $okRequestHeader = 'HTTP/1.1 200 OK';
  protected static $conflictRequestHeader = 'HTTP/1.1 409 Conflict';

  public static function notFoundResponse($messages) {
    $response['status_code_header'] = self::$notFoundHeader;
    $response['body']['status'] = 404;
    $response['body']['message'] = $messages;
    return $response;
  }

  public static function unprocessableEntityResponse($messages) {
    $response['status_code_header'] = self::$unprocessableEntityHeader;
    $response['body']['status'] = 422;
    $response['body']['message'] = $messages;
    return $response;
  }

  public static function badRequestResponse($messages) {
    $response['status_code_header'] = self::$badRequestHeader;
    $response['body']['status'] = 400;
    $response['body']['message'] = $messages;
    return $response;
  }

  public static function successResponse($messages) {
    $response['status_code_header'] = self::$okRequestHeader;
    $response['body']['status'] = 200;
    $response['body']['message'] = $messages;
    return $response;
  }
  
  public static function conflictResponse($messages) {
    $response['status_code_header'] = self::$conflictRequestHeader;
    $response['body']['status'] = 409;
    $response['body']['message'] = $messages;
    return $response;
  }
}