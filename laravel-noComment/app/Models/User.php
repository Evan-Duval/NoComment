<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    use HasFactory;

    protected $table = 'users';
    protected $primaryKey = 'id_user';

    



    protected $fillable = [
        'first_name', 
        'last_name',
         'username',
          'birthday',
        'email', 
        'password',
         'rank',
          'logo',
           'bio',
         'certified'
    ];

    public function posts()
    {
        return $this->hasMany(Post::class, 'id_user');
    }

    public function comments()
    {
        return $this->hasMany(Comment::class, 'id_user');
    }
}
