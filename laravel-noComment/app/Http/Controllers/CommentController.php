<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use Illuminate\Http\Request;
use Illuminate\Http\Response;


class CommentController extends Controller
{
    public function index()
    {
        return Comment::all();
    }

    public function show($id)
    {
        return Comment::findOrFail($id);
    }

    public function store(Request $request)
    {
        return Comment::create($request->all());
    }


    public function update(Request $request, $id)
{
    $comment = Comment::find($id);

    if (!$comment) {
        return response()->json(['message' => 'Comment not found'], 404);
    }

    $validatedData = $request->validate([
        'content' => 'required|string',
    ]);

    $comment->update($validatedData);

    return response()->json($comment, 200);
}

}
