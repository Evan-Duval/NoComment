<?php

namespace App\Http\Controllers;

use App\Models\Like;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class LikeController extends Controller
{
    public function getLikesByPost(Request $request, $postId): JsonResponse
    {
        $likeNumber = Like::where('id_post', $postId)->count();

        $userId = $request->query('userId');
        if ($userId) {
            $userLikes = Like::where('id_post', $postId)
                ->where('id_user', $userId)
                ->exists();

            return response()->json([
                'like_number' => $likeNumber,
                'user_like' => $userLikes
            ]);
        }

        return response()->json([
            'like_number' => $likeNumber
        ]);
    }

    public function getLikesByComment($commentId): JsonResponse
    {
        $likes = Like::where('id_comment', $commentId)->get();
        return response()->json($likes);
    }
    
    public function likePost(Request $request, $postId): JsonResponse
    {
        $userId = $request->query('userId');
        if (!$userId) {
            return response()->json(['message' => 'User not found'], 400);
        }

        // Vérifie si le like existe déjà pour éviter les doublons
        $exists = Like::where('id_user', $userId)->where('id_post', $postId)->exists();
        if (!$exists) {
            $like = new Like();
            $like->id_user = $userId;
            $like->id_post = $postId;
            $like->save();
        }

        return response()->json(['message' => 'Post liked successfully'], 201);
    }

    public function unlikePost(Request $request, $postId): JsonResponse
    {
        $userId = $request->query('userId');
        if (!$userId) {
            return response()->json(['message' => 'User not found'], 400);
        }
        
        $like = Like::where('id_user', $userId)->where('id_post', $postId)->first();
        if ($like) {
            $like->delete();
        }

        return response()->json(['message' => 'Post unliked successfully'], 200);
    }

    public function likeComment(Request $request, $commentId): JsonResponse
    {
        $like = new Like();
        $like->user_id = $request->user()->id;
        $like->comment_id = $commentId;
        $like->save();

        return response()->json(['message' => 'Comment liked successfully', 201]);
    }

    public function unlikeComment(Request $request, $commentId): JsonResponse
    {
        $like = Like::where('id_user', $request->user()->id)->where('id_comment', $commentId)->first();
        if ($like) {
            $like->delete();
        }

        return response()->json(['message' => 'Comment unliked successfully', 200]);
    }
}
