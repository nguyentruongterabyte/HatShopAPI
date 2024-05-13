<?php
require 'vendor/autoload.php';
use Dotenv\Dotenv;
use Src\System\DatabaseConnector;
use Src\System\FirebaseConnector;


$dotenv = new DotEnv(__DIR__);
$dotenv -> load();

$dbConnection = (new DatabaseConnector())->getConnection();
$factory = (new FirebaseConnector())->getFactory();