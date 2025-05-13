<?php

namespace App\Http\Controllers;

use App\Models\Group;
use Illuminate\Http\Request;

class GroupController extends Controller
{
    // 1. Créer un groupe
    public function store(Request $request)
    {
        // Validation des données
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'logo' => 'nullable|string|max:255',
        ]);

        // Créer le groupe
        $group = Group::create($validated);

        return response()->json($group, 201);  // Retourner le groupe créé
    }

    // 2. Lire tous les groupes
    public function index()
    {
        $groups = Group::all();  // Récupérer tous les groupes

        return response()->json($groups);
    }

    // 3. Lire un groupe spécifique
    public function show($id)
    {
        // Trouver le groupe par son ID
        $group = Group::findOrFail($id);

        return response()->json($group);
    }

    // 4. Mettre à jour un groupe
    public function update(Request $request, $id)
    {
        // Trouver le groupe par son ID
        $group = Group::findOrFail($id);

        // Validation des données
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'logo' => 'nullable|string|max:255',
        ]);

        // Mettre à jour les informations du groupe
        $group->update($validated);

        return response()->json($group);
    }

    // 5. Supprimer un groupe
    public function destroy($id)
    {
        // Trouver le groupe par son ID
        $group = Group::findOrFail($id);

        // Supprimer le groupe
        $group->delete();

        return response()->json(['message' => 'Group deleted successfully']);
    }
}
