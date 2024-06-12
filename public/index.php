<?php
require '../bootstrap.php';

use Src\Controller\BillController;
use Src\Controller\CartController;
use Src\Controller\CategoriesController;
use Src\Controller\LocationController;
use Src\Controller\OrderController;
use Src\Controller\ProductController;
use Src\Controller\RatingController;
use Src\Controller\ReportController;
use Src\Controller\UserController;
use Src\System\JWT;
use Src\Utils\Utils;

// CORS Headers
header("Access-Control-Allow-Origin: http://localhost:5173"); // Allow only your client origin
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: OPTIONS, GET, POST, PUT, DELETE");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, withCredentials");
header("Access-Control-Allow-Credentials: true");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    header('HTTP/1.1 200 OK');
    exit();
}

// JWT
$secretKey = getenv("SECRET_KEY") ?? '3fN8@#sjk12#FJeio1@!$jifD;fi13Rjkd81';
$jwt = new JWT($secretKey);

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
// Extracting the query string from the URL
$queryString = parse_url($_SERVER['REQUEST_URI'], PHP_URL_QUERY);
// parse 
parse_str($queryString, $params);
$uri = explode('/', $uri);
// request method
$requestMethod = $_SERVER['REQUEST_METHOD'];
// all of out endpoints start wilt /product
// everything else results in a 404 Not found
if ($uri[1] !== 'hatshop' || $uri[2] !== 'api') {
  header('HTTP/1.1 404 Not Found');
  exit();
}

// endpoint
$endpoint = $uri[3];
$requestName = isset($uri[4]) ? $uri[4] : null;

$requiresAuth = false;

$protectedEndpoints = [
  'product' => [],
  'order' => [],
  'cart' => [],
  'rating' => [],
  'bill' => [],
  'report' => []
];

if (isset($protectedEndpoints[$endpoint])) {
  if (count($protectedEndpoints[$endpoint]) === 0 || (isset($uri[4]) && in_array($uri[4], $protectedEndpoints[$endpoint]))) {
    $requiresAuth = true;
  }
}

if ($requiresAuth) {
  $token = $jwt->getBearerToken();
  if ($token) {
    $decoded = $jwt->validateJWT($token);

    if (!$decoded) {
      $response = Utils::unauthorizedResponse('Từ chối truy cập. Token không hợp lệ');
      header('HTTP/1.1 401 Unauthorized');
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    } 
  } else {
    $response = Utils::unauthorizedResponse('Từ chối truy cập. Chưa cung cấp token');
    header('HTTP/1.1 401 Unauthorized');
    header('Content-type: application/json');
    echo json_encode($response['body']);
    exit();
  }
}

switch ($endpoint) {
  case 'product':
    $isUploadImage = isset($uri[4]) && strcasecmp($uri[4], 'upload-image') == 0;
    $page = isset($params['page']) ? $params['page'] : null;
    $amount = isset($params['amount']) ? $params['amount'] : null;
    $id = isset($params['maSanPham']) ? $params['maSanPham'] : null;
    $key = isset( $params['key']) ? $params['key'] : null;

    // pass the request method to the ProductController and process the HTTP request;
    $controller = new ProductController($dbConnection, $requestMethod, $page, $amount, $id, $key, $factory, $isUploadImage);
    $controller->processRequest();
    break;
  case 'cart':
    $userId = isset($params['userId']) ? $params['userId'] : null;

    $controller = new CartController($dbConnection, $requestMethod, $userId);
    $controller->processRequest();
    break;
  case 'user':
    $userId = isset($params['userId']) ? $params['userId'] : null;
    $key = isset($params['key']) ? $params['key'] : null;
    $reset = isset($params['reset']) ? $params['reset'] : null;

    $controller = new UserController($dbConnection, $requestMethod, $mail, $key, $reset,$userId, $requestName, $jwt);
    $controller->processRequest();
    break;
  case 'categories':
    $controller = new CategoriesController($dbConnection, $requestMethod);
    $controller->processRequest();
    break;
  case 'order':
    $userId = isset($params['userId']) ? $params['userId'] : null;

    $controller = new OrderController( $dbConnection, $requestMethod, $userId, $requestName);
    $controller->processRequest();
    break;
  case 'reports':
    $year = isset($params['year']) ? $params['year'] : 2024;

    $controller = new ReportController($dbConnection, $requestMethod, $requestName, $year);
    $controller->processRequest();
    break;
  case 'bill':
    $orderId = isset($params['maDonHang']) ? $params['maDonHang'] : 0;

    $controller = new BillController($dbConnection, $requestMethod, $orderId);
    $controller->processRequest();
    break;
  case 'location':
    $controller = new LocationController( $dbConnection, $requestMethod);
    $controller->processRequest();
    break;
  case 'rating':
    $controller = new RatingController($dbConnection, $requestMethod, $requestName, $factory);
    $controller->processRequest();
    break;
  default:
    header('HTTP/1.1 404 Not Found');
    break;
}
