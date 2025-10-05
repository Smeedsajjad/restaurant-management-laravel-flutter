<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MenuItem extends Model
{
    protected $fillable = ['category_id', 'name', 'description', 'base_price', 'images', 'is_available'];

    protected $casts = [
        'images' => 'array',
        'is_available' => 'boolean',
        'base_price' => 'decimal:2',
    ];
    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function variants()
    {
        return $this->hasMany(Variant::class);
    }

    public function modifiers()
    {
        return $this->hasMany(Modifier::class);
    }
}
