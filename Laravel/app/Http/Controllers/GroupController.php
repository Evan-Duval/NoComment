<?php

namespace App\Http\Controllers;

use App\Models\Group;
use Illuminate\Http\Request;

class GroupController extends Controller
{
    public function index()
    {
        return Group::all();
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
