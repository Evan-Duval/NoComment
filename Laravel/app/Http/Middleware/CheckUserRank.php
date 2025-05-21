<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckUserRank
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$ranks): Response
    {
        if (!$request->user() || !in_array($request->user()->rank, $ranks)) {
            return response()->json(['error' => "Vous n'avez pas les droits nécessaire pour accéder à cette ressource", 'rank' => $request->user()->rank], 403);
        }
        return $next($request);
    }
}
