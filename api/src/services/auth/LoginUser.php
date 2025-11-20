<?php

namespace App\Services\Auth;

use \PDO;
use App\Db;

require_once __DIR__ . '/../../Db.php';

function LoginUser($request, $response, $args)
{
    $data = $request->getParsedBody();
    $username = $data["username"];
    $password = $data["password"]; // Already encrypted from client side

    try {
        $db = new Db();
        $conn = $db->connect();

        $sql = "SELECT user_id, username, password, is_admin FROM users WHERE username = :username";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':username', $username);
        $stmt->execute();
        
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        $conn = null;
        $db = null;

        if (!$user) {
            $error = array(
                "success" => false,
                "message" => "User not found"
            );
            $response->getBody()->write(json_encode($error));
            return $response
                ->withHeader('content-type', 'application/json')
                ->withStatus(404);
        }

        // Compare encrypted passwords
        if ($user['password'] === $password) {
            $successData = array(
                "success" => true,
                "message" => "Login successful",
                "user_id" => $user['user_id'],
                "username" => $user['username'],
                "is_admin" => $user['is_admin']
            );
            $response->getBody()->write(json_encode($successData));
            return $response
                ->withHeader('content-type', 'application/json')
                ->withStatus(200);
        } else {
            $error = array(
                "success" => false,
                "message" => "Invalid password"
            );
            $response->getBody()->write(json_encode($error));
            return $response
                ->withHeader('content-type', 'application/json')
                ->withStatus(401);
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
