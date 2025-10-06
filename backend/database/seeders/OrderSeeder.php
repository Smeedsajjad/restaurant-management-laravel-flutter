<?php

namespace Database\Seeders;

use App\Models\MenuItem;
use App\Models\Order;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class OrderSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $customers = User::all();
        $menuItems = MenuItem::all();

        foreach ($customers as $customer) {
            $address = $customer->addresses()->inRandomOrder()->first();

            $order = Order::create([
                'user_id' => $customer->id,
                'address_id' => $address?->id,
                'order_number' => strtoupper(Str::random(8)),
                'subtotal' => 200,
                'tax' => 10,
                'total' => 210,
                'status' => 'delivered',
                'payment_method' => 'COD',
                'note' => 'Leave package at the door.',
            ]);

            $order->items()->create([
                'menu_item_id' => $menuItems->random()->id,
                'quantity' => 2,
                'price' => 100,
                'subtotal' => 200,
            ]);
        }
    }
}
