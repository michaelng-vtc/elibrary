<?php

require_once __DIR__ . '/../vendor/autoload.php';

$app = Slim\Factory\AppFactory::create();

// Add CORS middleware to handle cross-origin requests
$app->add(function ($request, $handler) {
    $response = $handler->handle($request);
    return $response
        ->withHeader('Access-Control-Allow-Origin', '*')
        ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
        ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
});

// Handle preflight OPTIONS requests
$app->options('/{routes:.+}', function ($request, $response, $args) {
    return $response;
});

//handle json format
$app->addBodyParsingMiddleware();

// Add Slim routing middleware
$app->addRoutingMiddleware();

// Set the base path to run the app in a subdirectory.
// This path is used in urlFor().
$app->add(new Selective\BasePath\BasePathMiddleware($app));

$app->addErrorMiddleware(true, true, true);

// Define app routes here
$app->get('/', function ($request, $response) {
    $response->getBody()->write('Hello, World!');
    return $response;
})->setName('root'); //<<<set root

//require all php files in /../src/services subdirectories
foreach (glob(__DIR__ . '/../src/services/*/*.php') as $filename) {
    // var_dump($filename); // for debug only
    require_once($filename);
}

// Book routes
$app->get('/books/all', 'App\Services\Book\GetAllBooks');
$app->post('/books/add', 'App\Services\Book\AddBook');
$app->put('/books/update/{book_id}', 'App\Services\Book\UpdateBook');
$app->delete('/books/delete/{book_id}', 'App\Services\Book\DeleteBook');

// User authentication routes
$app->post('/users/register', 'App\Services\Auth\RegisterUser');
$app->post('/users/login', 'App\Services\Auth\LoginUser');
$app->get('/users/check/{username}', 'App\Services\Auth\CheckUsername');

// Run app
$app->run();
