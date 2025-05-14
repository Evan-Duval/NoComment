<?php

namespace App\Http\Controllers;

use App\Models\Group;
use Illuminate\Http\Request;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Validation\ValidationException;

class GroupController extends Controller
{
    // 1. Créer un groupe

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string|max:255',
                'logo' => 'nullable|string|max:255',
            ]);

            $group = Group::create($validated);

            return response()->json($group, 201);
        } catch (ValidationException $e) {
            return response()->json(['error' => 'Validation échouée', 'messages' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erreur serveur', 'message' => $e->getMessage()], 500);
        }
    }

    // 2. Lire tous les groupes

    public function index()
    {
        try {
            $groups = Group::all();
            return response()->json($groups);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erreur serveur', 'message' => $e->getMessage()], 500);
        }
    }

    // 3. Lire un groupe spécifique
     public function show($id)
    {
        try {
            $group = Group::findOrFail($id);
            return response()->json($group);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Groupe non trouvé'], 404);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erreur serveur', 'message' => $e->getMessage()], 500);
        }
    }





    // 4. Mettre à jour un groupe
   public function update(Request $request, $id)
    {
        try {
            $group = Group::findOrFail($id);

            $validated = $request->validate([
                'name' => 'sometimes|string|max:255',
                'logo' => 'nullable|string|max:255',
            ]);

            $group->update($validated);

            return response()->json($group);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Groupe non trouvé'], 404);
        } catch (ValidationException $e) {
            return response()->json(['error' => 'Validation échouée', 'messages' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erreur serveur', 'message' => $e->getMessage()], 500);
        }
    }

    // 5. Supprimer un groupe
        public function destroy($id)
    {
        try {
            $group = Group::findOrFail($id);
            $group->delete();

            return response()->json(['message' => 'Groupe supprimé avec succès']);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Groupe non trouvé'], 404);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erreur serveur', 'message' => $e->getMessage()], 500);
        }
    }

}
