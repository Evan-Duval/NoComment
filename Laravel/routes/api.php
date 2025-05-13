<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

use App\Http\Controllers\GroupController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\CommentController;







// routes publiques
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);



Route::apiResource('comments', CommentController::class);
Route::apiResource('posts', PostController::class);
Route::apiResource('groups', GroupController::class);



Route::middleware('auth:sanctum')->group(function () {


       // Info utilisateur connecté
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Déconnexion
    Route::post('/logout', [AuthController::class, 'logout']);


   


});

