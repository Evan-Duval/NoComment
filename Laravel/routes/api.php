<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\GroupController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\CommentController;
use App\Models\Group;
use App\Models\User;
use Illuminate\Support\Facades\Auth;


Route::prefix('auth')->group(function () {
    Route::post('login', [AuthController::class, 'login']);
    Route::post('register', [AuthController::class, 'register']);
    Route::post('reset-password', [AuthController::class, 'resetpassword']);
    Route::post('update-password', [AuthController::class, 'changePassword']);
    Route::post('delete-user/{id}', [AuthController::class, 'delete']);

    Route::group(['middleware' => 'auth:sanctum'], function () {
        Route::get('logout', [AuthController::class, 'logout']);
        Route::get('user', [AuthController::class, 'user']);
    });
});


Route::apiResource('groups', GroupController::class);

// Routes API pour les posts
Route::apiResource('posts', PostController::class);

// Récupérer les posts d’un groupe spécifique
Route::get('/groups/{id}/posts', [PostController::class, 'getPostsByGroup']);


// Routes API pour les commentaires
Route::apiResource('comments', CommentController::class);

Route::put('comments/{id}', [CommentController::class, 'update']);

Route::middleware('auth:sanctum')->get('/groups/{group}/follow-status', function (Group $group) {
    return response()->json([
        'is_following' => Auth::user()->groups->contains($group->id_group)
    ]);
});

Route::middleware('auth:sanctum')->post('/groups/{group}/toggle-follow', function (Group $group) {
    $user = Auth::user();

    if ($user->groups->contains($group->id_group)) {
        $user->groups()->detach($group->id_group);
        return response()->json(['following' => false]);
    } else {
        $user->groups()->attach($group->id_group);
        return response()->json(['following' => true]);
    }
});
