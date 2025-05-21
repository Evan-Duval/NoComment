<?php

use App\Http\Controllers\LikeController;
use App\Http\Controllers\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

use App\Http\Controllers\GroupController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\CommentController;
use App\Models\Group;
use App\Models\User;
use Illuminate\Support\Facades\Auth;


Route::prefix('user')->group(function () {
    Route::get('getAllUsers', [UserController::class, 'getAllUsers']);
    Route::get('getUsernameByUserId/{userId}', [UserController::class, 'getUsernameByUserId']);
    Route::get('getOtherUserById/{userId}', [UserController::class, 'getOtherUserById']);
});


Route::prefix('auth')->group(function () {
    Route::post('login', [AuthController::class, 'login']);
    Route::post('register', [AuthController::class, 'register']);
    Route::post('update-password', [AuthController::class, 'changePassword']);
    Route::post('update-user/{id}', [AuthController::class, 'updateUser']);
    Route::post('delete-user/{id}', [AuthController::class, 'delete']);

    Route::group(['middleware' => 'auth:sanctum'], function () {
        Route::get('logout', [AuthController::class, 'logout']);
        Route::get('user', [AuthController::class, 'user']);
    });
});

Route::prefix('groups')->group(function () {
    Route::post('create', [GroupController::class, 'createGroup']);
    Route::get('get-all', [GroupController::class, 'index']);
    Route::get('getGroup/{groupId}', [GroupController::class, 'getGroupById']);
    Route::get('getUserGroups/{userId}', [GroupController::class, 'getUserGroups']);
    Route::get('getGroupMembers/{groupId}', [GroupController::class, 'getGroupMembers']);
    Route::post('updateGroup/{groupId}', [GroupController::class, 'update']);

    // Routes protégées par Sanctum
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('{group}/follow-status', function (Group $group) {
            return response()->json([
                'is_following' => Auth::user()->groups->contains($group->id_group)
            ]);
        });

        Route::post('{group}/toggle-follow', function (Group $group) {
            $user = Auth::user();
            if ($user->groups->contains($group->id_group)) {
                $user->groups()->detach($group->id_group);
                return response()->json(['following' => false]);
            } else {
                $user->groups()->attach($group->id_group);
                return response()->json(['following' => true]);
            }
        });

        Route::post('/toggleFollowGroup/{groupId}', [GroupController::class, 'toggleFollowGroup']);
    });
});

Route::prefix('posts')->group(function () {
    Route::post('/create', [PostController::class, 'create']);
    Route::get('/getById/{id}', [PostController::class, 'show']);
    Route::get('getLastPosts', [PostController::class, 'getLastPosts']);
    
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('getByGroup/{groupId}', [PostController::class, 'getByGroup']);
        Route::put('/updateMyPost/{postId}', [PostController::class, 'updateMyPost']);
        Route::put('/update/{postId}', [PostController::class, 'update'])->middleware('role:admin');
        Route::delete('/delete/{postId}', [PostController::class, 'destroy'])->middleware('role:admin');
    });
});

Route::prefix('comments')->group(function () {
    Route::get('getByPost/{postId}', [CommentController::class, 'getByPost']);
    Route::get('getCommentNumberByPost/{postId}', [CommentController::class, 'getCommentNumberByPost']);
    Route::get('getLastComments', [CommentController::class, 'getLastComments']);
    Route::post('create', [CommentController::class, 'create']);
    Route::get('/getById/{id}', [CommentController::class, 'show']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::put('/update/{commentId}', [CommentController::class, 'update'])->middleware('role:admin');
        Route::delete('/delete/{commentId}', [CommentController::class, 'destroy'])->middleware('role:admin');
    });
});

Route::prefix('likes')->group(function () {
    Route::get('getLikesByPost/{postId}', [LikeController::class, 'getLikesByPost']);
    Route::get('getLikesByComment/{commentId}', [LikeController::class, 'getLikesByComment']);
    Route::post('addLike', [LikeController::class, 'store']);
    Route::delete('removeLike/{id}', [LikeController::class, 'destroy']);
    Route::delete('removePostLike/{postId}', [LikeController::class, 'removePostLike']);
    Route::delete('removeCommentLike/{commentId}', [LikeController::class, 'removeCommentLike']);
});
