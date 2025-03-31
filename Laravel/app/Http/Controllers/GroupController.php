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

    public function getByUser($id): JsonResponse {
        $groups = Group::where('user_id', $id)->get();
        return response()->json($groups);
    }

    public function show($id)
    {
        return Group::findOrFail($id);
    }

    public function store(Request $request)
    {
        return Group::create($request->all());
    }

    public function update(Request $request, $id)
    {
        $group = Group::findOrFail($id);
        $group->update($request->all());
        return $group;
    }

    public function destroy($id)
    {
        return Group::destroy($id);
    }
}
