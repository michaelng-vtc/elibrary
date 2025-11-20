<?php

namespace App\Services\Book;

use \PDO;
use \PDOException;
use App\Db;

require_once __DIR__ . '/../../Db.php';

function DeleteBook($request, $response, $args)
{
    $book_id = $args["book_id"];
    try {
        $db = new Db();
        $conn = $db->connect();

        $sql = "DELETE FROM books WHERE book_id = $book_id";

        $stmt = $conn->prepare($sql);
        $result = $stmt->execute();

        $db = null;
        $response->getBody()->write(json_encode($result));
        return $response
            ->withHeader('content-type', 'application/json')
            ->withStatus(200);
    } catch (PDOException $e) {
        $error = array(
            "message" => $e->getMessage()
        );
        $response->getBody()->write(json_encode($error));
        return $response
            ->withHeader('content-type', 'application/json')
            ->withStatus(500);
    }
}
