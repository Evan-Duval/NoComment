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

// Voir tous les likes pour un post
Route::get('posts/{postId}/likes', [LikeController::class, 'likesForPost']);

// Voir tous les likes pour un commentaire
Route::get('comments/{commentId}/likes', [LikeController::class, 'likesForComment']);

// Vérifier si un utilisateur a liké un post ou un commentaire
Route::post('likes/hasLiked', [LikeController::class, 'hasLiked']);









Route::middleware('auth:sanctum')->group(function () {


       // Info utilisateur connecté
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Déconnexion
    Route::post('/logout', [AuthController::class, 'logout']);


   


});



