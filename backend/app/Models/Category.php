<?php

namespace App\Models;

use Filament\Support\Concerns\HasIconPosition;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    use HasIconPosition;
    protected $fillable = ['name', 'image', 'is_active', 'position'];


    public function menuItems() {
        return $this->hasMany(MenueItems::class);
    }
}
