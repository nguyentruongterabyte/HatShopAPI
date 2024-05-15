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
    $statement = "INSERT INTO `user`(`email`, `password`, `username`, `mobile`)
                  VALUES (:email, :hashedPassword, :username, :mobile)";
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array(
        "email"=> $input["email"],
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
  
  /**
   * Summary of update password where email = $email
   * @param string $email
   * @param string $hashedPassword : hashed Password
   * @return int
   */
  public function updatePassword($email, $hashedPassword) {
    $statement = "UPDATE `user` SET `password` = '$hashedPassword' WHERE `email` = '$email'";	
    
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute();
      $result = $statement->rowCount();
      return $result;
    } catch (\PDOException $e) {
      exit($e->getMessage());
    }
  }

  /**
   * find user by id
   * @param int $id
   * @return object
   */
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

  /**
   * find user by email
   * @param string $email
   * @return object
   */
  public function findByEmail($email) {
    $statement = "SELECT * FROM `user` WHERE `email` = :email";

    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array("email"=> $email));
      $result = $statement->fetch(\PDO::FETCH_ASSOC);
      return $result;
    } catch (\PDOException $e) {
      exit($e->getMessage());
    }
  }

  /**
   * get all information of users
   * @return array
   */
  public function getAll() {
    $statement = "SELECT `id`, `email`, `username`, `mobile` FROM `user` WHERE 1";
  
    try {
    
      $statement = $this->db->query($statement);
      $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
      return $result;
    } catch (\PDOException $e) {
      exit($e->getMessage());
    }
  }


  

  public function delete($id) {

  }
}