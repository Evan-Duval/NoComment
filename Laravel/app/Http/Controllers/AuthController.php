<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use App\Models\User;
use Exception;

class AuthController extends Controller
{
    // 1. Créer un utilisateur
    public function register(Request $request)
    {
        try {
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

        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de l\'inscription de l\'utilisateur.'], 500);
        }
    }

    // 2. Connexion
    public function login(Request $request)
    {
        try {
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
                'message' => 'Connexion réussie.',
                'token' => $token,
            ], 200);

        } catch (ValidationException $e) {
            return response()->json(['error' => $e->errors()], 422);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la connexion.'], 500);
        }
    }

    // 3. Déconnexion
    public function logout(Request $request)
    {
        try {
            $request->user()->tokens()->delete();

            return response()->json([
                'message' => 'Déconnexion réussie.',
            ]);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la déconnexion.'], 500);
        }
    }

    // 4. Récupérer tous les utilisateurs
    public function index()
    {
        try {
            $users = User::all();
            return response()->json($users);

        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la récupération des utilisateurs.'], 500);
        }
    }

    // 5. Récupérer un utilisateur par ID
    public function show($id)
    {
        try {
            $user = User::findOrFail($id);
            return response()->json($user);

        } catch (Exception $e) {
            return response()->json(['error' => 'Utilisateur non trouvé.'], 404);
        }
    }

    // 6. Mettre à jour un utilisateur
    public function update(Request $request, $id)
    {
        try {
            $user = User::findOrFail($id);

            $fields = $request->validate([
                'first_name' => 'nullable|string|max:50',
                'last_name' => 'nullable|string|max:50',
                'username' => 'nullable|string|max:50|unique:users,username,' . $id,
                'birthday' => 'nullable|date',
                'email' => 'nullable|string|email|unique:users,email,' . $id,
                'password' => 'nullable|string|confirmed',
                'rank' => 'nullable|string|max:50',
                'logo' => 'nullable|string',
                'bio' => 'nullable|string',
                'certified' => 'nullable|boolean',
            ]);

            // Mettre à jour l'utilisateur
            $user->update($fields);

            return response()->json($user);

        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la mise à jour de l\'utilisateur.'], 500);
        }
    }

    // 7. Supprimer un utilisateur
    public function destroy($id)
    {
        try {
            $user = User::findOrFail($id);
            $user->delete();

            return response()->json(['message' => 'Utilisateur supprimé avec succès.']);

        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la suppression de l\'utilisateur.'], 500);
        }
    }
}
