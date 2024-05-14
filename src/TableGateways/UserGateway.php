<?php
namespace Src\TableGateways;

class UserGateway extends AbstractTableGateways {

  private $db = null;

  public function __construct($db)
  {
    $this->db = $db;
  }
  /**
   * Create new user
   * @param array $input
   * @return int
   */
  public function create(array $input) {
    $statement = "INSERT INSERT INTO `user`(`email`, `password`, `username`, `mobile`)
                  VALUES (:email, :hashedPassword, :username, :mobile')";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
        "emaile"=> $input["email"],
        "hashedPassword"=> $input["hashedPassword"],
        "username"=> $input["username"],
        "mobile"=> $input["mobile"],
      ));
      return $statement->rowCount();
    } catch (\PDOException $e) {
      exit($e->getMessage());
    }  
  }

  /**
   * Summary of isEmailExists
   * @param string $email
   * @return bool
   */
  public function isEmailExists($email) {
    $statement = "SELECT 1 FROM `user` WHERE `email` = '$email'";
    try {
      $result = $this->db->query($statement);
      if ($result->rowCount() > 0) {
        return true;
      }
      return false;
    } catch (\PDOException $e) {
      exit($e->getMessage());
    }
  }

  public function update(array $input) {
    $statement = "";
  }
  
  public function find($id) {
    $statement = "SELECT * FROM `user` WHERE `id` = :id";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array("id" => $id));
      $result = $statement->fetch(\PDO::FETCH_ASSOC);
      return $result;
    } catch (\PDOException $e) {
      exit($e->getMessage());
    }
  }

  public function delete($id) {

  }
}