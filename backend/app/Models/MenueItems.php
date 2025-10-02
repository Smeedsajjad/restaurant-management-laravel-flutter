<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MenueItems extends Model
{
     protected $fillable = ['category_id', 'name', 'description', 'base_price', 'image', 'is_available'];

    public function category() {
        return $this->belongsTo(Category::class);
    }

    public function variants() {
        return $this->hasMany(Variant::class);
    }

    public function modifiers() {
        return $this->hasMany(Modifier::class);
    }
}
