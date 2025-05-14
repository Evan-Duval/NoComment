<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

use App\Http\Controllers\GroupController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\LikeController;







// routes publiques
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);



Route::apiResource('comments', CommentController::class);
Route::apiResource('posts', PostController::class);
Route::apiResource('groups', GroupController::class);


//gerer les likes 

// Ajouter un like
Route::post('likes', [LikeController::class, 'store']);

// Supprimer un like
Route::delete('likes/{id}', [LikeController::class, 'destroy']);



    // Récupérer tous les utilisateurs
    Route::get('/users', [AuthController::class, 'index']);  

    // Récupérer un utilisateur par ID
    Route::get('/users/{id}', [AuthController::class, 'show']);  

    // Mettre à jour un utilisateur
    Route::put('/users/{id}', [AuthController::class, 'update']);  

    // Supprimer un utilisateur
    Route::delete('/users/{id}', [AuthController::class, 'destroy']); 







Route::middleware('auth:sanctum')->group(function () {


       // Info utilisateur connecté
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Déconnexion
    Route::post('/logout', [AuthController::class, 'logout']);


   


});



