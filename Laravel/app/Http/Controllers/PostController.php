<?php

namespace App\Http\Controllers;

use App\Models\Group;
use App\Models\Post;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PostController extends Controller
{

    public function create(Request $request)
    {
        $validatedData = $request->validate([
            'title' => 'required|string|max:255',
            'text' => 'required|string',
            'location' => 'required|string',
            'media' => 'nullable|string',
            'datetime' => 'required',
            'id_user' => 'required|integer|exists:users,id',
            'id_group' => 'required|integer|exists:groups,id_group',
        ]);
        
        return Post::create([
            'title' => $validatedData['title'],
            'text' => $validatedData['text'],
            'media' => $validatedData['media'] ?? null,
            'location' => $validatedData['location'],
            'datetime' => $validatedData['datetime'],
            'id_user' => $validatedData['id_user'],
            'id_group' => $validatedData['id_group'],
        ]); 
    }

     // Affiche un post spécifique
       public function show($id)
    {
        try {
            $post = Post::with('user')->findOrFail($id); // je charge le post avec l'utilisateur
            return response()->json($post);
          
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'error' => 'Post non retrouvé.'
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Une erreur est survenue.',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function getByGroup($groupId): JsonResponse 
    {
        $group = Group::find($groupId);

        if (!$group) {
            return response()->json(['message' => 'Group not found'], 404);
        }

        $posts = Post::where('id_group', $groupId)->orderBy('created_at', 'desc')->get();

        return response()->json($posts);
    }


    public function update(Request $request, $id)
    {
        try {
            $post = Post::findOrFail($id);

            $validated = $request->validate([
                'title' => 'sometimes|required|string|max:255',
                'text' => 'sometimes|required|string',
                'media' => 'nullable|string',
                'location' => 'nullable|string',
                'datetime' => 'sometimes|required|date',
                'id_user' => 'sometimes|required|exists:users,id',
                'id_group' => 'nullable|exists:groups,id_group', // Assure-toi que c’est bien id_group dans la table
            ]);

            $post->update($validated);

            return response()->json($post, 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json(['error' => 'Post non trouvé'], 404);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json(['error' => 'Validation échouée', 'messages' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erreur serveur', 'message' => $e->getMessage()], 500);
        }
    }


    // Supprime un post spécifique
    public function destroy($id)
    {
        try {
            $post = Post::findOrFail($id);
            $post->delete();

            return response()->json(['message' => 'Post supprimé avec succès'], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json(['error' => 'Post non trouvé'], 404);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erreur lors de la suppression', 'message' => $e->getMessage()], 500);
        }
    }

    public function getPostsByGroup($groupId)
    {
        try {
            $posts = Post::with('user')
                ->where('id_group', $groupId)
                ->orderBy('datetime', 'desc')
                ->get();

            return response()->json($posts, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erreur lors de la récupération des posts pour ce groupe.',
                'message' => $e->getMessage()
            ], 500);
        }
    }
}






