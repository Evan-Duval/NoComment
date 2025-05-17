<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    use HasFactory;

    protected $table = 'posts';
    protected $primaryKey = 'id_post';

    protected $fillable = ['title', 'text', 'media', 'location', 'datetime', 'id_user', 'id_group'];

    // Ajouter cet attribut pour forcer l'ajout du champ id dans le JSON
    protected $appends = ['id'];

    // Créer un accessor pour id, qui retourne id_post
    public function getIdAttribute()
    {
        return $this->attributes['id_post'];
    }

    public function comments()
    {
        return $this->hasMany(Comment::class, 'id_post');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }
}
