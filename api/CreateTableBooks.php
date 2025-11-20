<?php 

$servername = "localhost";
$username = "root"; 
$password = "netlab123"; 
$dbname = "elibrary"; 

try { 
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password); 
    // set the PDO error mode to exception 
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); 
    // sql to create table 
    $sql = "CREATE TABLE books ( 
        book_id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
        title VARCHAR(50) NOT NULL,
        authors VARCHAR(50) NOT NULL,
        publishers VARCHAR(50) NOT NULL,
        date VARCHAR(50) NOT NULL,
        isbn VARCHAR(50) NOT NULL,
        status INT(6) NOT NULL DEFAULT 0,
        borrowed_by  INT(6) DEFAULT -1,
        last_updated  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE (book_id, title, isbn)
    )"; 
    // use exec() because no results are returned 
    $conn->exec($sql); 
    echo "Table books has been created successfully"; 
    
    // Close connection 
    $conn = null; 
} catch(PDOException $e) { 
    echo $sql . "<br>" . $e->getMessage();
    // Close connection 
    $conn = null; 
}

$conn = null; 
?>