<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
    // Liste tous les posts
    public function index()
{
    // Teste d'abord sans les relations
    return Post::all();  // Retirer `with()` pour simplifier.
}
    // Crée un nouveau post
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'text' => 'required|string',
            'media' => 'nullable|string',
            'location' => 'nullable|string',
            'datetime' => 'required|date',
            'id_user' => 'required|exists:users,id',
            'id_group' => 'nullable|exists:groups,id', // Groupe peut être null
        ]);

        $post = Post::create($validated);
        return response()->json($post, 201); // Retourne le post créé avec un code 201
    }

    // Affiche un post spécifique
    public function show($id)
    {
        $post = Post::with(['user', 'comments'])->findOrFail($id); // Inclut l'utilisateur et les commentaires
        return response()->json($post);
    }

    // Met à jour un post spécifique
    public function update(Request $request, $id)
    {
        $post = Post::findOrFail($id);

        $validated = $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'text' => 'sometimes|required|string',
            'media' => 'nullable|string',
            'location' => 'nullable|string',
            'datetime' => 'sometimes|required|date',
            'id_user' => 'sometimes|required|exists:users,id',
            'id_group' => 'nullable|exists:groups,id',
        ]);

        $post->update($validated); // Met à jour le post
        return response()->json($post);
    }

    // Supprime un post spécifique
    public function destroy($id)
    {
        $post = Post::findOrFail($id);
        $post->delete();

        return response()->json(['message' => 'Post deleted']);
    }
}
