<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\GroupController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\CommentController;

// Routes API pour les utilisateurs
Route::apiResource('users', UserController::class);

// Routes API pour les groupes
Route::apiResource('groups', GroupController::class);

// Routes API pour les posts
Route::apiResource('posts', PostController::class);

// Routes API pour les commentaires
Route::apiResource('comments', CommentController::class);

Route::put('comments/{id}', [CommentController::class, 'update']);
