<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function getUsernameByUserId($userid):JsonResponse {
         $user = User::find($userid);

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        return response()->json([
            'username' => $user->username,
        ]);
    }

    public function getOtherUserById($userId): JsonResponse {
    $user = User::find($userId);

    if (!$user) {
        return response()->json(['message' => 'User not found'], 404);
    }

    return response()->json([
        'username' => $user->username,
        'bio' => $user->bio,
        'logo' => $user->logo,
        'certified' => $user->certified,
    ]);
}
}
