<?php

namespace App\Http\Controllers;

use App\Models\Group;
use App\Models\Post;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function index()
    {
        return Post::all();
    }

    public function create(Request $request)
    {
        $validatedData = $request->validate([
            'title' => 'required|string|max:255',
            'text' => 'required|string',
            'location' => 'required|string',
            'media' => 'nullable',
            'datetime' => 'required',
            'id_user' => 'required|integer|exists:users,id',
            'id_group' => 'required|integer|exists:groups,id_group',
        ]);
        
        return Post::create([
            'title' => $validatedData['title'],
            'text' => $validatedData['text'],
            'media' => $validatedData['media'] ?? null,
            'location' => $validatedData['location'],
            'datetime' => $validatedData['datetime'],
            'id_user' => $validatedData['id_user'],
            'id_group' => $validatedData['id_group'],
        ]);
    }

    public function getByGroup($groupId): JsonResponse {
        $group = Group::find($groupId);

        if (!$group) {
            return response()->json(['message' => 'Group not found'], 404);
        }

        $posts = Post::where('id_group', $groupId)->orderBy('created_at', 'desc')->get();

        return response()->json($posts);
    }

    public function show($id)
    {
        return Post::findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $post = Post::findOrFail($id);
        $post->update($request->all());
        return $post;
    }

    public function destroy($id)
    {
        return Post::destroy($id);
    }
}
