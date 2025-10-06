<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AddressResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            "id"=> $this->id,
            "user_id"=> $this->user_id,
            "label"=> $this->label,
            "street"=> $this->street,
            "city"=> $this->city,
            "state"=> $this->state,
            "postal_code"=> $this->postal_code,
            "is_default"=> (bool) $this->is_default,
        ];
    }
}
