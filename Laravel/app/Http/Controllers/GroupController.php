<?php

namespace App\Http\Controllers;

use App\Models\Group;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Validation\ValidationException;

class GroupController extends Controller
{

    public function getGroupById($groupId): JsonResponse
    {
        $group = Group::find($groupId);

        if (!$group) {
            return response()->json(['message' => 'Group not found'], 404);
        }

        return response()->json($group);
    }

    public function getUserGroups($userId): JsonResponse
    {
        $user = User::find($userId);

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        $groups = $user->groups;

        return response()->json($groups);
    }

    public function getGroupMembers($groupId): JsonResponse
    {
        $group = Group::find($groupId);

        if (!$group) {
            return response()->json(['message' => 'Group not found'], 404);
        }

        $members = $group->users()->get();

        return response()->json($members);
    }

    public function createGroup(Request $request)
    {
        // Valider les données entrantes
        $validatedData = $request->validate([
            'name' => 'required|string|max:20',
            'description' => 'required|string|max:255',
            'logo' => 'nullable|string',
            'group_owner' => 'required|exists:users,id',
        ]);

        // Créer le groupe avec le propriétaire
        $group = Group::create([
            'name' => $validatedData['name'],
            'description' => $validatedData['description'],
            'logo' => $validatedData['logo'] ?? "default_logo.png",
            'group_owner' => $validatedData['group_owner'],
        ]);

        // Ajouter le propriétaire du groupe à la table de jointure
        $group->users()->attach($validatedData['group_owner']);

        return response()->json($group, 201);
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
                'name' => 'required|string|max:255',
                'description' => 'required|string|max:255',
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
