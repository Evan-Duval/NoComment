<?php

namespace App\Providers;

use Illuminate\Support\Facades\Schema;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Schema;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void {}


    // dans la méthode boot(), inclure la ligne suivante
    public function boot()
    {
        Schema::defaultStringLength(191);
    }
}
