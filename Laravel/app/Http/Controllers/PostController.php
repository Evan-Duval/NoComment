<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function index()
    {
        return Post::all();
    }

    public function show($id)
    {
        return Post::findOrFail($id);
    }

    public function store(Request $request)
    {
        return Post::create($request->all());
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

    public function getPostsByGroup($groupId)
    {
        try {
            $posts = Post::with('user')
                ->where('id_group', $groupId)
                ->orderBy('datetime', 'desc')
                ->get();

            return response()->json($posts, 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erreur lors de la récupération des posts pour ce groupe.',
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
