<?php

use App\Http\Controllers\LikeController;
use App\Http\Controllers\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\GroupController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\CommentController;

Route::prefix('user')->group(function () {
    Route::get('getUsernameByUserId/{userId}', [UserController::class, 'getUsernameByUserId']);
});

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
    Route::get('getGroupMembers/{groupId}', [GroupController::class, 'getGroupMembers']);
    Route::post('addUserToGroup/{groupId}', [GroupController::class, 'addUserToGroup']); // todo
    Route::post('updateGroup/{groupId}', [GroupController::class,'update']);
    Route::delete('removeUserFromGroup/{groupId}/{userId}', [GroupController::class,'removeUserFromGroup']); // todo
});

// Routes API pour les posts
Route::prefix('posts')->group(function() {
    Route::post('create', [PostController::class, 'create']);
    Route::get('getByGroup/{groupId}', [PostController::class, 'getByGroup']);
});

Route::prefix('likes')->group(function() {
    Route::get('getLikesByPost/{postId}', [LikeController::class, 'getLikesByPost']);
    Route::post('likePost', [LikeController::class, 'likePost']);
    Route::post('unlikePost', [LikeController::class, 'unlikePost']);
});

// Routes API pour les commentaires
Route::apiResource('comments', CommentController::class);

Route::put('comments/{id}', [CommentController::class, 'update']);
