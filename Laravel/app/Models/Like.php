<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Like extends Model
{
    use HasFactory;

    // Table associée à ce modèle
    protected $table = 'likes';
    
    // Clé primaire
    protected $primaryKey = 'id_like';

    // Attributs pouvant être assignés en masse
    protected $fillable = [
        'id_user', 
        'id_post', 
        'id_comment'
    ];

    // Relation avec l'utilisateur
    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }

    // Relation avec le post
    public function post()
    {
        return $this->belongsTo(Post::class, 'id_post');
    }

    // Relation avec le commentaire
    public function comment()
    {
        return $this->belongsTo(Comment::class, 'id_comment');
    }
}
