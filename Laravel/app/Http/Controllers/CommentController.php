<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Exception;

class CommentController extends Controller
{
    public function getCommentNumberByPost($postId)
    {
        $commentNumber = Comment::where('id_post', $postId)->count();

        return response()->json(['comment_number' => $commentNumber]);
    }

    public function getByPost($postId)
    {
        if(!Post::find($postId)) {
            return response()->json(['message' => 'Post not found'], 404);
        }

        $comments = Comment::where('id_post', $postId)->orderBy('created_at', 'desc')->get();

        return response()->json($comments);
    }

    public function create(Request $request)
    {
      try {
        
          $validatedData = $request->validate([
              'text' => 'required|string',
              'media' => 'nullable|string',
              'datetime' => 'required|string',
              'id_user' => 'required|integer|exists:users,id',
              'id_post' => 'required|integer|exists:posts,id_post',
          ]);

          if (!Post::find($validatedData['id_post'])) {
              return response()->json(['message' => 'Post not found'], 404);
          }

          $comment = Comment::create($validatedData);
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
