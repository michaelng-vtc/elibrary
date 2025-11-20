<?php

namespace App\Services\Auth;

use \PDO;
use App\Db;

require_once __DIR__ . '/../../Db.php';

function CheckUsername($request, $response, $args)
{
    $username = $args["username"];

    try {
        $db = new Db();
        $conn = $db->connect();

        $sql = "SELECT COUNT(*) as count FROM users WHERE username = :username";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':username', $username);
        $stmt->execute();
        
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        $exists = $result['count'] > 0;

        $conn = null;
        $db = null;

        $responseData = array(
            "exists" => $exists,
            "username" => $username
        );

        $response->getBody()->write(json_encode($responseData));
        return $response
            ->withHeader('content-type', 'application/json')
            ->withStatus(200);
    } catch (\PDOException $e) {
        $error = array(
            "error" => $e->getMessage()
        );
        $response->getBody()->write(json_encode($error));
        return $response
            ->withHeader('content-type', 'application/json')
            ->withStatus(500);
    }
}
