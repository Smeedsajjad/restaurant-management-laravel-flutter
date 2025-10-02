<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Modifier extends Model
{
    protected $fillable = ['menu_item_id', 'name', 'type', 'is_required'];

    public function menuItem() {
        return $this->belongsTo(MenueItems::class);
    }

    public function options() {
        return $this->hasMany(ModifierOption::class);
    }
}
