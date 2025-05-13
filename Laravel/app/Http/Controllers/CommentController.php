<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    // Liste tous les commentaires
    public function index()
    {
        return Comment::with(['user', 'post'])->get();
    }

    // Crée un commentaire
    public function store(Request $request)
    {
        $validated = $request->validate([
            'text' => 'required|string',
            'media' => 'nullable|string',
            'datetime' => 'required|date',
            'id_user' => 'required|exists:users,id',
            'id_post' => 'required|exists:posts,id',
        ]);

        $comment = Comment::create($validated);
        return response()->json($comment, 201);
    }

    // Affiche un commentaire spécifique
    public function show($id)
    {
        $comment = Comment::with(['user', 'post'])->findOrFail($id);
        return response()->json($comment);
    }

    // Met à jour un commentaire
    public function update(Request $request, $id)
    {
        $comment = Comment::findOrFail($id);

        $validated = $request->validate([
            'text' => 'sometimes|required|string',
            'media' => 'nullable|string',
            'datetime' => 'sometimes|required|date',
            'id_user' => 'sometimes|required|exists:users,id',
            'id_post' => 'sometimes|required|exists:posts,id',
        ]);

        $comment->update($validated);
        return response()->json($comment);
    }

    // Supprime un commentaire
    public function destroy($id)
    {
        $comment = Comment::findOrFail($id);
        $comment->delete();

        return response()->json(['message' => 'Comment deleted']);
    }
}
