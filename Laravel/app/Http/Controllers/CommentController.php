<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use Illuminate\Http\Request;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Exception;

class CommentController extends Controller
{



    // Liste tous les commentaires
      public function index()
    {
        try {
            $comments = Comment::with(['user', 'post'])->get();
            return response()->json($comments);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la récupération des commentaires', 'details' => $e->getMessage()], 500);
        }
    }



    // Crée un commentaire
    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'text' => 'required|string',
                'media' => 'nullable|string',
                'datetime' => 'required|date',
                'id_user' => 'required|exists:users,id',
                'id_post' => 'required|exists:posts,id_post',
            ]);

            $comment = Comment::create($validated);
            return response()->json($comment, 201);

        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la création du commentaire', 'details' => $e->getMessage()], 500);
        }
    }





    // Affiche un commentaire spécifique
   public function show($id)
    {
        try {
            $comment = Comment::with(['user', 'post'])->findOrFail($id);
            return response()->json($comment);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Commentaire non trouvé'], 404);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la récupération du commentaire', 'details' => $e->getMessage()], 500);
        }
    }






    // Met à jour un commentaire
      public function update(Request $request, $id)
    {
        try {
            $comment = Comment::findOrFail($id);

            $validated = $request->validate([
                'text' => 'sometimes|required|string',
                'media' => 'nullable|string',
                'datetime' => 'sometimes|required|date',
                'id_user' => 'sometimes|required|exists:users,id',
                'id_post' => 'sometimes|required|exists:posts,id_post',
            ]);

            $comment->update($validated);
            return response()->json($comment);

        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Commentaire non trouvé'], 404);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la mise à jour', 'details' => $e->getMessage()], 500);
        }
    }


    // Supprime un commentaire
      public function destroy($id)
    {
        try {
            $comment = Comment::findOrFail($id);
            $comment->delete();

            return response()->json(['message' => 'Commentaire supprimé avec succès']);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Commentaire non trouvé'], 404);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la suppression', 'details' => $e->getMessage()], 500);
        }
    }



}
