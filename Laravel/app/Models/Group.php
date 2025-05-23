<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\User;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Group extends Model
{
    use HasFactory;

    protected $table = 'groups';
    protected $primaryKey = 'id_group';

    protected $fillable = [
        'name',
        'description',
        'logo',
        'group_owner',
    ];

    public function users()
    {
        return $this->belongsToMany(User::class, 'group_user', 'id_group', 'id_user');
    }

    public function groupOwner()
    {
        return $this->belongsTo(User::class, 'group_owner');
    }
}
