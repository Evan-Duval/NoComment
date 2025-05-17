<?php

namespace App\Http\Controllers;

use App\Models\Like;
use Illuminate\Http\Request;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Validation\ValidationException;
use Exception;

class LikeController extends Controller
{
    // 1. Créer un like pour un post ou un commentaire
    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'id_user' => 'required|exists:users,id',
                'id_post' => 'nullable|exists:posts,id_post',
                'id_comment' => 'nullable|exists:comments,id_comment',
            ]);

            if (isset($validated['id_post'])) {
                $like = Like::create([
                    'id_user' => $validated['id_user'],
                    'id_post' => $validated['id_post'],
                ]);
            } elseif (isset($validated['id_comment'])) {
                $like = Like::create([
                    'id_user' => $validated['id_user'],
                    'id_comment' => $validated['id_comment'],
                ]);
            } else {
                return response()->json(['error' => 'Un like doit être associé à un post ou un commentaire.'], 400);
            }

            return response()->json($like, 201);

        } catch (ValidationException $e) {
            return response()->json(['error' => $e->errors()], 422);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la création du like.'], 500);
        }
    }

    // 2. Supprimer un like
    public function destroy($id)
    {
        try {
            $like = Like::findOrFail($id);
            $like->delete();

            return response()->json(['message' => 'Like supprimé avec succès.']);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Like non trouvé.'], 404);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la suppression du like.'], 500);
        }
    }
}
