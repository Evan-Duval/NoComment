<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

Route::prefix('auth')->group( function () {
    Route::post('login', [AuthController::class, 'login']);
    Route::post('register', [AuthController::class, 'register']);
    Route::post('reset-password', [AuthController::class, 'resetpassword']);
    Route::post('update-password', [AuthController::class,'changePassword']);
    Route::post('delete-user/{id}', [AuthController::class, 'delete']);
  
    Route::group(['middleware' => 'auth:sanctum'], function() {
      Route::get('logout', [AuthController::class, 'logout']);
      Route::get('user', [AuthController::class, 'user']);
    });
  });