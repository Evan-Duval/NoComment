<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{

       // Crée un nouveau post
       //on pourra creer le post meme si n'a pas de groupe , le date time est obligatoire, ça va se gérer dans le front end lors de la création du post 
    public function store(Request $request)
    {

        try {
$validated = $request->validate([
            'title' => 'required|string|max:255',
            'text' => 'required|string',
            'media' => 'nullable|string',
            'location' => 'nullable|string',
            'datetime' => 'required|date',
            'id_user' => 'required|exists:users,id',
            'id_group' => 'nullable|exists:groups,id_group', // Groupe peut être null (les user n'appartient a aucun groupe , ex il veut poster sur son profil  personel)
        ]);
        
        $post = Post::create($validated);
        return response()->json($post, 201);

            } catch (\Exception $e) {
           return response()->json(['error' => $e->getMessage()], 500);
            }
        
       
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



    // Liste tous les posts
public function index()
{
    try {
        $posts = Post::with('user')->get();

        return response()->json($posts, 200); 
    } catch (\Exception $e) {
        return response()->json([
            'error' => 'Une erreur est survenue lors de la récupération des posts.',
            'message' => $e->getMessage()
        ], 500); 
    }
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
}






