<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Group extends Model
{
    use HasFactory;

    protected $table = 'groups';
    protected $primaryKey = 'id_group';

    protected $fillable = [
    'name', 
    'description',
    'logo'];

    public function users()
    {
        return $this->belongsToMany(User::class, 'group_user', 'id_group', 'id_user');
    }
}
