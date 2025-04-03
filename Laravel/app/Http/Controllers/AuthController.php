<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

// use App\Mail\PasswordResetNotification;
use Illuminate\Support\Facades\Mail;

class AuthController extends Controller
{
    /**
     * Create user
     *
     * @param  [string] first_name
     * @param  [string] last_name
     * @param  [string] email
     * @param  [string] password
     * @param  [string] password_confirmation
     * @param  [date] birthday
     * @return [string] message
     */
    public function register(Request $request)
    {
        $request->validate([
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'username' => 'required|string',
            'birthday' => 'required|date',
            'email' => 'required|string|unique:users',
            'password' => 'required|string|min:8',
            'c_password' => 'required|same:password',
            'rank' => 'string',
            'logo' => 'string',
            'bio' => 'string',
            'certified' => 'boolean',
            'deleted_at' => 'date',
        ]);

        $user = new User([
            'first_name'  => $request->first_name,
            'last_name'  => $request->last_name,
            'username'  => $request->username,
            'email' => $request->email,
            'password' => bcrypt($request->password),
            'birthday' => $request->birthday,
            'rank' => $request->rank ?? "user",
            'logo' => $request->logo ?? null,
            'bio' => $request->bio ?? null,
            'certified' => $request->certified ?? 0,
            'deleted_at' => null,
        ]);

        if ($user->save()) {
            $tokenResult = $user->createToken('Personal Access Token');
            $token = $tokenResult->plainTextToken;

            return response()->json([
                'message' => 'Successfully created user!',
                'accessToken' => $token,
            ], 201);
        } else {
            return response()->json(['error' => 'Provide proper details']);
        }
    }

    /**
     * Login user and create token
     *
     * @param  [string] email
     * @param  [string] password
     * @param  [boolean] remember_me
     */

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string',
            'remember_me' => 'boolean'
        ]);

        $credentials = request(['email', 'password']);
        if (!Auth::attempt($credentials)) {
            return response()->json([
                'message' => 'Unauthorized'
            ], 401);
        }

        $user = $request->user();

        // Vérification du champ deleted_at
        if ($user->deleted_at !== null) {
            return response()->json([
                'message' => 'Your account has been desactivated.'
            ], 403);
        }

        $tokenResult = $user->createToken('Personal Access Token');
        $token = $tokenResult->plainTextToken;

        return response()->json([
            'user_info' => $user->only(['id', 'first_name', 'last_name', 'email', 'username', 'rank', 'logo', 'bio', 'certified', 'birthday']),
            'accessToken' => $token,
            'token_type' => 'Bearer',
        ]);
    }

    /**
     * Get the authenticated User
     *
     * @return [json] user object
     */
    public function user(Request $request)
    {
        return response()->json($request->user());
    }

    /**
     * Logout user (Revoke the token)
     *
     * @return [string] message
     */
    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'message' => 'Successfully logged out'
        ]);
    }

    /**
     * Change le mot de passe d'un utilisateur
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function changePassword(Request $request)
    {
        // Validation des données
        $request->validate([
            'email' => ['required', 'email', 'exists:users,email'],
            'current_password' => ['required'],
            'new_password' => ['required', Password::defaults(), 'confirmed'],
            'new_password_confirmation' => ['required']
        ]);

        try {
            // Recherche de l'utilisateur par email
            $user = User::where('email', $request->email)->first();

            // Vérification du mot de passe actuel
            if (!Hash::check($request->current_password, $user->password)) {
                return response()->json([
                    'message' => 'Le mot de passe actuel est incorrect',
                    'status' => 'error'
                ], 422);
            }

            // Mise à jour du mot de passe
            $user->password = Hash::make($request->new_password);
            $user->save();

            return response()->json([
                'message' => 'Mot de passe modifié avec succès',
                'status' => 'success'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Une erreur est survenue lors du changement de mot de passe',
                'error' => $e->getMessage(),
                'status' => 'error'
            ], 500);
        }
    }

    /**
     * This PHP function deletes a user by setting the 'deleted_at' timestamp field to the current time
     * for soft deletion.
     *
     * @param int id The `delete` function you provided is used to perform a soft delete on a user
     * record in the database. The function takes an integer parameter `` which represents the
     * unique identifier of the user to be deleted.
     *
     * @return JsonResponse A JSON response is being returned. If the user with the specified ID is
     * found, a success message indicating that the user has been soft deleted is returned with a
     * status code of 200. If the user is not found, a message indicating that the user was not found
     * is returned with a status code of 404.
     */
    public function delete(int $id): JsonResponse
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json(['message' => 'Utilisateur introuvable'], 404);
        }

        $user
            ->where('id', $id)
            ->update(['deleted_at' => Now()]);

        return response()->json(['message' => 'Utilisateur supprimé (soft delete)'], 200);
    }

    /**
     * The function `resetpassword` resets a user's password, sends a notification email with the new
     * password, and handles exceptions.
     *
     * @param Request request The code you provided is a PHP function that resets a user's password. It
     * first validates the email provided in the request, then searches for the user with that email,
     * resets the password to a default value 'Password1234', saves the new password hashed, sends an
     * email notification with the new password
     *
     * @return `resetpassword` function returns a JSON response with a success message if the
     * password reset and email sending were successful. If an error occurs during the process, it
     * returns a JSON response with an error message and the specific error message caught in the catch
     * block.
     */

    // public function resetpassword(Request $request)
    // {
    //     // Validation de l'email
    //     $request->validate([
    //         'email' => ['required', 'email', 'exists:users,email'],
    //     ]);

    //     try {
    //         // Recherche de l'utilisateur
    //         $user = User::where('email', $request->email)->first();

    //         // Reset du mot de passe
    //         $newPassword = 'Password1234';
    //         $user->password = Hash::make($newPassword);
    //         $user->save();

    //         // Envoi de l'email
    //         Mail::to($user->email)->send(new PasswordResetNotification($newPassword));

    //         return response()->json([
    //             'message' => 'Mot de passe réinitialisé avec succès et email envoyé',
    //             'status' => 'success'
    //         ], 200);

    //     } catch (\Exception $e) {
    //         return response()->json([
    //             'message' => 'Une erreur est survenue lors de la réinitialisation du mot de passe',
    //             'error' => $e->getMessage(),
    //             'status' => 'error'
    //         ], 500);
    //     }
    // }

}


/*
Exctracted from https://demos.pixinvent.com/vuexy-vuejs-admin-template/documentation/guide/laravel-integration/laravel-sanctum-authentication.html
*/
