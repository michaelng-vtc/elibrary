<?php

namespace App\Services\Auth;

use \PDO;
use App\Db;

require_once __DIR__ . '/../../Db.php';

function RegisterUser($request, $response, $args)
{
    $data = $request->getParsedBody();
    $username = $data["username"];
    $password = $data["password"]; // Already encrypted from client side

    try {
        $db = new Db();
        $conn = $db->connect();

        // Check if username already exists
        $checkSql = "SELECT COUNT(*) as count FROM users WHERE username = :username";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->bindParam(':username', $username);
        $checkStmt->execute();
        $result = $checkStmt->fetch(PDO::FETCH_ASSOC);

        if ($result['count'] > 0) {
            $error = array(
                "success" => false,
                "message" => "Username already exists"
            );
            $response->getBody()->write(json_encode($error));
            return $response
                ->withHeader('content-type', 'application/json')
                ->withStatus(409); // Conflict
        }

        // Insert new user
        $sql = "INSERT INTO users (username, password, is_admin) VALUES (:username, :password, 0)";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':password', $password);

        if ($stmt->execute()) {
            $userId = $conn->lastInsertId();
            $successData = array(
                "success" => true,
                "message" => "User registered successfully",
                "user_id" => $userId,
                "username" => $username
            );
            
            $conn = null;
            $db = null;

            $response->getBody()->write(json_encode($successData));
            return $response
                ->withHeader('content-type', 'application/json')
                ->withStatus(201);
        } else {
            throw new \Exception("Failed to register user");
        }
    } catch (\PDOException $e) {
        $error = array(
            "success" => false,
            "message" => $e->getMessage()
        );
        $response->getBody()->write(json_encode($error));
        return $response
            ->withHeader('content-type', 'application/json')
            ->withStatus(500);
    }
}
