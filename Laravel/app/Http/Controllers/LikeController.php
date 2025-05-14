<?php

namespace App\Http\Controllers;

use App\Models\Like;
use App\Models\Post;
use App\Models\Comment;
use App\Models\User;
use Illuminate\Http\Request;

class LikeController extends Controller
{
    // 1. Créer un like pour un post ou un commentaire
    public function store(Request $request)
    {
        $validated = $request->validate([
            'id_user' => 'required|exists:users,id',
            'id_post' => 'nullable|exists:posts,id_post',
            'id_comment' => 'nullable|exists:comments,id_comment',
        ]);

        // Si le like est pour un post
        if ($validated['id_post']) {
            $like = Like::create([
                'id_user' => $validated['id_user'],
                'id_post' => $validated['id_post'],
            ]);
        }
        // Si le like est pour un commentaire
        elseif ($validated['id_comment']) {
            $like = Like::create([
                'id_user' => $validated['id_user'],
                'id_comment' => $validated['id_comment'],
            ]);
        }

        return response()->json($like, 201);  // Retourner le like créé
    }

    // 2. Supprimer un like
    public function destroy($id)
    {
        $like = Like::findOrFail($id);
        $like->delete();

        return response()->json(['message' => 'Like removed successfully']);
    }




    
}