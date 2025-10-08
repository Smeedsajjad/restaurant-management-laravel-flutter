<?php

namespace Database\Seeders;

use App\Models\Cart;
use App\Models\MenuItem;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CartSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = User::all();
        $menuItems = MenuItem::all();

        if ($users->isEmpty() || $menuItems->isEmpty()) {
            $this->command->warn('⚠️ No users or menu items found. Please seed users and menu items first.');
            return;
        }

        // Create 2–3 cart items per user
        foreach ($users as $user) {
            $cartCount = rand(2, 3);

            for ($i = 0; $i < $cartCount; $i++) {
                $menuItem = $menuItems->random();
                $quantity = rand(1, 3);
                $price = $menuItem->base_price;
                $subtotal = $price * $quantity;

                Cart::updateOrCreate(
                    [
                        'user_id' => $user->id,
                        'menu_item_id' => $menuItem->id,
                    ],
                    [
                        'quantity' => $quantity,
                        'price' => $price,
                        'subtotal' => $subtotal,
                    ]
                );
            }
        }

        $this->command->info('✅ CartSeeder: Dummy cart data created successfully!');
    }
}
