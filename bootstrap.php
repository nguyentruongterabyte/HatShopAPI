<?php
require 'vendor/autoload.php';
use Dotenv\Dotenv;
use Src\System\DatabaseConnector;
use Src\System\FirebaseConnector;
use Src\System\SMTPEmailService;

// Bỏ qua các cảnh báo deprecated
error_reporting(E_ALL & ~E_DEPRECATED);
ini_set('display_errors', 1);

$dotenv = new DotEnv(__DIR__);
$dotenv -> load();

$dbConnection = (new DatabaseConnector())->getConnection();
$factory = (new FirebaseConnector())->getFactory();
$mail = (new SMTPEmailService())->getMail();