<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use App\Models\User;

class AuthController extends Controller
{
  public function register(Request $request)
{
    // Validation des données
    $fields = $request->validate([
        'first_name' => 'required|string|max:50',
        'last_name' => 'required|string|max:50',
        'username' => 'nullable|string|max:50|unique:users,username',
        'birthday' => 'required|date',
        'email' => 'required|string|email|unique:users,email',
        'password' => 'required|string|confirmed',
        'rank' => 'nullable|string|max:50',
        'logo' => 'nullable|string',
        'bio' => 'nullable|string',
        'certified' => 'required|boolean',
    ]);

    // Création de l'utilisateur
    $user = User::create([
        'first_name' => $fields['first_name'],
        'last_name' => $fields['last_name'],
        'username' => $fields['username'] ?? null,
        'birthday' => $fields['birthday'],
        'email' => $fields['email'],
        'password' => bcrypt($fields['password']),
        'rank' => $fields['rank'] ?? null,
        'logo' => $fields['logo'] ?? null,
        'bio' => $fields['bio'] ?? null,
        'certified' => $fields['certified'],
    ]);

   
    return response()->json([
        'message' => 'Utilisateur créé avec succès.',
        'user' => $user,
    ], 201);
}




public function login(Request $request)
{
    // Validation des identifiants
    $fields = $request->validate([
        'email' => 'required|string|email',
        'password' => 'required|string',
    ]);

    // Recherche de l'utilisateur par email
    $user = User::where('email', $fields['email'])->first();

    // Vérification du mot de passe
    if (!$user || !Hash::check($fields['password'], $user->password)) {
        throw ValidationException::withMessages([
            'email' => ['Les identifiants sont incorrects.'],
        ]);
    }

    // Création du token
    $token = $user->createToken('auth_token')->plainTextToken;

    // Réponse avec le token d'authentification
    return response()->json([
    'message'=> 'Connexion réussie.',
        'token' => $token,
    ], 200);
}



    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'message' => 'Déconnexion réussie.',
        ]);
    }
}
