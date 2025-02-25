<?php

use Illuminate\Support\Facades\Route;
use PhpAmqpLib\Connection\AMQPStreamConnection;
use PhpAmqpLib\Connection\AMQPMessage;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/teste', function () {
    return 'Rota de teste';
});

Route::get('/send', function () {
    $connection = new AMQPStreamConnection('laravel-docker-rabbitmq-1', 5672, 'guest', 'guest');

    $channel = $connection->channel();
    $channel->queue_declare('envioEmail', false, false, false, false);

    $message = new AMQPMessage('Hello World Queue');

    $channel = $connection->channel();
    $channel->basic_publish($message, '', 'envioEmail');

    $channel->close();
    $connection->close();

    return "Message published to RabbitMQ \n";    
});