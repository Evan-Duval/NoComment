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

    public function store(Request $request)
    {
        return Group::create($request->all());
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
