<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MenuItemsResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'category_id' => $this->category_id,
            'category_name' => $this->whenLoaded('category', fn() => $this->category->name),
            'name' => $this->name,
            'description' => $this->description,
            'base_price' => $this->base_price,
            'images' => $this->images,
            'is_available' => $this->is_available,
        ];
    }
}
