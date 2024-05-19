<?php
namespace Src\System;

require '../vendor/autoload.php';
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use Src\Utils\Utils;

class SMTPEmailService {
  private $mail = null;
  public function __construct()
  {

    $this->mail = new PHPMailer(true);
    
    try {
      $this->mail -> CharSet = 'utf-8';
      $this->mail -> isSMTP();
      // enable SMTP authentication
      $this->mail -> SMTPAuth = true;
  
      // Gmail username
      $this->mail -> Username = getenv('SMTP_EMAIL');
      // Gmail password
      $this->mail -> Password = getenv('SMTP_PASSWORD');
      $this->mail -> SMTPSecure = "ssl";
  
      // Set gmail as the SMTP server
      $this->mail -> Host = "smtp.gmail.com";
      // Set the SMTP port for the gmail server
      $this->mail -> Port = "465";
      $this->mail -> From =  getenv('SMTP_EMAIL');
      $this->mail -> FromName = "Hat shop";
    } catch (Exception $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }

  public function getMail() {
    return $this->mail;
  }
}