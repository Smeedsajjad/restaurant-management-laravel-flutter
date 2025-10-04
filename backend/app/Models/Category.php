<?php

namespace App\Models;

use Filament\Support\Concerns\HasIconPosition;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    use HasIconPosition;
    protected $fillable = ['name', 'emoji', 'is_active', 'position'];


    public function menuItems()
    {
        return $this->hasMany(MenuItem::class);
    }
}
