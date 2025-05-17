<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Like extends Model
{
    use HasFactory;

    protected $table = 'likes';
    protected $primaryKey = 'id_like';

    protected $fillable = ['id_user', 'id_post', 'id_comment'];

    public function comments()
    {
        return $this->hasMany(Comment::class, 'id_post');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }

    public function post()
    {
        return $this->belongsTo(Post::class, 'id_post');
    }

    public function comment()
    {
        return $this->belongsTo(Comment::class, 'id_comment');
    }
}
