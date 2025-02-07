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
        Schema::create('likes', function (Blueprint $table) {
            $table->id('id_like');
            $table->foreignId('id_user')->constrained('users')->onDelete('cascade');
            $table->foreignId('id_post')->nullable()->constrained('posts')->onDelete('cascade');
            $table->foreignId('id_comment')->nullable()->constrained('comments')->onDelete('cascade');
            $table->timestamps();
        });
        
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('likes');
    }
};
