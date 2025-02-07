<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    // GET /api/users
    public function index()
    {
        return response()->json(User::all(), 200);
    }

    // GET /api/users/{id}
    public function show($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }
        return response()->json($user, 200);
    }

    // POST /api/users
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6',
            'rank' => 'required|string',
            'birthday' => 'required|date',
            'logo' => 'required|string' , 
            'bio' => 'required|string',
            'certified' => 'required|boolean'
            
        ]);

        $validatedData['password'] = bcrypt($request->password); // Hashing the password

        $user = User::create($validatedData);

        return response()->json($user, 201);
    }

    // PUT /api/users/{id}
    public function update(Request $request, $id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        $validatedData = $request->validate([
            'first_name' => 'sometimes|required|string|max:255',
            'last_name' => 'sometimes|required|string|max:255',
            'username' => 'sometimes|required|string|max:255',
            'email' => 'sometimes|required|string|email|max:255|unique:users,email,' . $id . ',id_user',
            'password' => 'sometimes|nullable|string|min:6',
            'rank' => 'sometimes|required|string',
            'birthday' => 'sometimes|required|date',
            'logo' => 'sometimes|required|string',
            'bio' => 'sometimes|required|string',
            'certified' => 'sometimes|required|boolean'
        ]);

        if ($request->has('password')) {
            $validatedData['password'] = bcrypt($request->password); // Hashing the password
        }

        $user->update($validatedData);

        return response()->json($user, 200);
    }

    // DELETE /api/users/{id}
    public function destroy($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        $user->delete();

        return response()->json(['message' => 'User deleted successfully'], 200);
    }
}
