<?php

namespace App\Http\Controllers;

use App\Models\Group;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class GroupController extends Controller
{
    public function index()
    {
        return Group::all();
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

    // public function show($id)
    // {
    //     return Group::findOrFail($id);
    // }

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

    public function update(Request $request, $id)
    {
        $group = Group::find($id);
        if (!$group) {
            return response()->json(['message' => 'Group not found'], 404);
        }

        $group->update($request->all());
        return $group;
    }

    // public function destroy($id)
    // {
    //     return Group::destroy($id);
    // }
}
