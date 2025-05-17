<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use App\Models\Post;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    public function getCommentNumberByPost($postId)
    {
        $commentNumber = Comment::where('id_post', $postId)->count();

        return response()->json(['comment_number' => $commentNumber]);
    }

    public function getByPost($postId)
    {
        if(!Post::find($postId)) {
            return response()->json(['message' => 'Post not found'], 404);
        }

        $comments = Comment::where('id_post', $postId)->orderBy('created_at', 'desc')->get();

        return response()->json($comments);
    }

    public function create(Request $request)
    {
        $validatedData = $request->validate([
            'text' => 'required|string',
            'datetime' => 'required|string',
            'id_user' => 'required|integer|exists:users,id',
            'id_post' => 'required|integer|exists:posts,id_post',
        ]);

        if (!Post::find($validatedData['id_post'])) {
            return response()->json(['message' => 'Post not found'], 404);
        }

        return Comment::create($validatedData);
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
