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
    {Schema::create('posts', function (Blueprint $table) {
        $table->id('id_post');
        $table->string('title');
        $table->text('text');
        $table->string('media')->nullable();
        $table->string('location')->nullable();
        $table->timestamp('datetime');
        $table->foreignId('id_user')->constrained('users')->onDelete('cascade');
        $table->foreignId('id_group')->nullable()->constrained('groups')->onDelete('cascade');
        $table->timestamps();
    });
    
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('posts');
    }
};
