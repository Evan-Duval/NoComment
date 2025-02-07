<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id('id_user');
            $table->string('first_name');
            $table->string('last_name');
            $table->string('username')->unique();
            $table->date('birthday');
            $table->string('email')->unique();
            $table->string('password');
            $table->string('rank');
            $table->string('logo')->nullable();
            $table->text('bio')->nullable();
            $table->boolean('certified')->default(false);
            $table->timestamps(); // created_at, updated_at
        });
        
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
