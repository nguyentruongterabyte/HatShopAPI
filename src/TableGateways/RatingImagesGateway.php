<?php
namespace Src\TableGateways;

use Src\Utils\Utils;

class RatingImagesGateway {
  private $db = null;

  public function __construct($db) {
    $this->db = $db;
  }

  /**
   * Summary of createRatingImages
   * @param int $ratingId maDanhGia
   * @param string $input JSON images
   * @return int
   */
  public function createRatingImages($ratingId, $input)
  {
    $statement = "call SP_CREATE_RATING_IMAGES (:ratingId, :json)";
    try {
      $statement = $this->db->prepare($statement);
      $statement->bindParam(":ratingId", $ratingId, \PDO::PARAM_INT);
      $statement->bindParam(":json", $input, \PDO::PARAM_STR);
      $statement->execute();
      $result = $statement->rowCount();
      return $result;
    } catch(\PDOException $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }


  /**
   * Get rating images
   * @param int $ratingId
   * @return array array of images of rating
   */
  public function getRatingImages($ratingId) {
    $statement = 'SELECT * FROM hinhanhdanhgia WHERE maDanhGia = :ratingId';
    try {
      $statement = $this->db->prepare($statement);
      $statement->execute(array('ratingId'=> $ratingId));
      return $statement->fetchAll(\PDO::FETCH_ASSOC);
    } catch(\PDOException $e) {
      $response = Utils::internalServerErrorResponse($e->getMessage());
      header($response['status_code_header']);
      header('Content-type: application/json');
      echo json_encode($response['body']);
      exit();
    }
  }
}