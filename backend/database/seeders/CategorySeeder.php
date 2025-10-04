<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Pizza',
                'emoji' => '🍕',
                'is_active' => true,
                'position' => 1,
            ],
            [
                'name' => 'Burgers',
                'emoji' => '🍔',
                'is_active' => true,
                'position' => 2,
            ],
            [
                'name' => 'Drinks',
                'emoji' => '🥤',
                'is_active' => true,
                'position' => 3,
            ],
            [
                'name' => 'Ice Cream',
                'emoji' => '🍦',
                'is_active' => true,
                'position' => 4,
            ],
            [
                'name' => 'Coffee',
                'emoji' => '☕',
                'is_active' => true,
                'position' => 5,
            ],
        ];

        foreach ($categories as $category) {
            Category::create($category);
        }
    }
}
