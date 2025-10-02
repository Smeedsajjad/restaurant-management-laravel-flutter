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
                'image' => 'categories/pizza.webp',
                'active' => true,
                'position' => 1,
            ],
            [
                'name' => 'Burgers',
                'image' => 'categories/burger.webp',
                'active' => true,
                'position' => 2,
            ],
            [
                'name' => 'Drinks',
                'image' => 'categories/drinks.webp',
                'active' => true,
                'position' => 3,
            ],
            [
                'name' => 'Desserts',
                'image' => 'categories/desserts.webp',
                'active' => true,
                'position' => 4,
            ],
        ];

        foreach ($categories as $category) {
            Category::create($category);
        }
    }
}
