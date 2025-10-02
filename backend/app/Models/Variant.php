<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Variant extends Model
{
     protected $fillable = ['menu_item_id', 'name', 'price'];

    public function menuItem() {
        return $this->belongsTo(MenuItem::class);
    }
}
