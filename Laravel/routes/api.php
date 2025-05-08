<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\GroupController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\CommentController;

Route::prefix('auth')->group(function () {
    Route::post('login', [AuthController::class, 'login']);
    Route::post('register', [AuthController::class, 'register']);
    Route::post('reset-password', [AuthController::class, 'resetpassword']); // todo
    Route::post('update-password', [AuthController::class, 'changePassword']);
    Route::post('update-user/{id}', [AuthController::class, 'updateUser']);
    Route::post('delete-user/{id}', [AuthController::class, 'delete']);

    Route::group(['middleware' => 'auth:sanctum'], function () {
        Route::get('logout', [AuthController::class, 'logout']);
        Route::get('user', [AuthController::class, 'user']);
    });
});

Route::prefix('groups')->group(function () {
    Route::post('create', [GroupController::class,'createGroup']);
    Route::get('get-all', [GroupController::class, 'index']);
    Route::get('getGroup/{groupId}', [GroupController::class, 'getGroupById']);
    Route::get('getUserGroups/{userId}', [GroupController::class, 'getUserGroups']);
    Route::post('addUserToGroup/{groupId}', [GroupController::class, 'addUserToGroup']); // todo
    Route::post('updateGroup/{groupId}', [GroupController::class,'update']);
    Route::delete('removeUserFromGroup/{groupId}/{userId}', [GroupController::class,'removeUserFromGroup']); // todo
});
Route::apiResource('groups', GroupController::class);

// Routes API pour les posts
Route::apiResource('posts', PostController::class);

// Routes API pour les commentaires
Route::apiResource('comments', CommentController::class);

Route::put('comments/{id}', [CommentController::class, 'update']);
