<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            "id" => $this->id,
            "user_id" => $this->address_id,
            "order_number" => $this->order_number,
            "subtotal" => $this->subtotal,
            "tax" => $this->tax,
            "total" => $this->total,
            "status" => $this->status,
            "payment_method" => $this->payment_method,
            "note" => $this->note,
            'address' => new AddressResource($this->whenLoaded('address')),
            'created_at' => $this->created_at?->format('Y-m-d H:i:s'),
            'updated_at' => $this->updated_at?->format('Y-m-d H:i:s'),
        ];
    }
}
