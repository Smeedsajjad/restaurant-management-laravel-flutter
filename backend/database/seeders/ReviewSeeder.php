<?php

namespace Database\Seeders;

use App\Models\MenuItem;
use App\Models\Review;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ReviewSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = User::all();
        $menuItems = MenuItem::all();

        if ($users->isEmpty() || $menuItems->isEmpty()) {
            $this->command->warn('⚠️ No users or menu items found. Skipping review seeding.');
            return;
        }

        foreach (range(1, 10) as $i) {
            Review::create([
                'user_id' => $users->random()->id,
                'menu_item_id' => $menuItems->random()->id,
                'rating' => rand(3, 5),
                'comment' => fake()->sentence(),
                'is_approved' => true,
            ]);
        }
    }
}
