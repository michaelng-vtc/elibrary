<?php

namespace App\Services\Book;

use \PDO;
use \PDOException;
use App\Db;

require_once __DIR__ . '/../../Db.php';

function AddBook($request, $response, $args)
{
    $data = $request->getParsedBody();
    $title = $data["title"];
    $authors = $data["authors"];
    $publishers = $data["publishers"];
    $date = $data["date"];
    $isbn = $data["isbn"];

    try {
        $db = new Db();
        $conn = $db->connect();

        // begin the transaction
        $conn->beginTransaction();

        // our SQL statements
        $sql = "INSERT INTO books (title, authors, publishers, date, isbn)
VALUES ('$title', '$authors', '$publishers', '$date', '$isbn')";
        $conn->exec($sql);

        // commit the transaction
        $result = $conn->commit();

        // Close connection
        $conn = null;
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
