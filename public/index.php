<?php
require '../bootstrap.php';
use Src\Controller\ProductController;

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: OPTIONS,GET,POST,PUT,DELETE");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");


$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
// Extracting the query string from the URL
$queryString = parse_url($_SERVER['REQUEST_URI'], PHP_URL_QUERY);
// parse 
parse_str($queryString, $params);
$uri = explode('/', $uri);

// all of out endpoints start wilt /product
// everything else results in a 404 Not found
if ($uri[1] !== 'hatshop' || $uri[2] !== 'api' || $uri[3] !== 'product') {
  header('HTTP/1.1 404 Not Found');
  exit();
}

$isUploadImage = isset($uri[4]) && strcasecmp($uri[4], 'upload-image') == 0;

$page = isset($params['page']) ? $params['page'] : null;
$amount = isset($params['amount']) ? $params['amount'] : null;
$id = isset($params['maSanPham']) ? $params['maSanPham'] : null;
$key = isset( $params['key']) ? $params['key'] : null;

$requestMethod = $_SERVER['REQUEST_METHOD'];

// pass the request method to the ProductController and process the HTTP request;
$controller = new ProductController($dbConnection, $requestMethod, $page, $amount, $id, $key, $factory, $isUploadImage);
$controller->processRequest();