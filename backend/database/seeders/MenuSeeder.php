<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MenuSeeder extends Seeder
{
    public function run(): void
    {
        /* 1.  Categories ----------------------------------------------------- */
        $cat = $this->seedCategories();

        /* 2.  Menu Items ----------------------------------------------------- */
        $items = $this->seedItems($cat);

        /* 3.  Variants ------------------------------------------------------- */
        $this->seedVariants($items);

        /* 4.  Modifiers + Options ------------------------------------------- */
        $this->seedModifiers($items);
    }

    /* ---------------------------------------------------------------------- */
    /*  CATEGORY
    /* ---------------------------------------------------------------------- */
    private function seedCategories(): array
    {
        $list = [
            ['name' => 'Pizza', 'emoji' => '🍕', 'position' => 1, 'is_active' => true],
            ['name' => 'Drinks', 'emoji' => '🥤', 'position' => 2, 'is_active' => true],
            ['name' => 'Burgers', 'emoji' => '🍔', 'position' => 3, 'is_active' => true],
            ['name' => 'Desserts', 'emoji' => '🍦', 'position' => 4, 'is_active' => true],
        ];

        $out = [];
        foreach ($list as $cat) {
            $cat['created_at'] = now();
            $cat['updated_at'] = now();
            $out[$cat['name']] = DB::table('categories')->insertGetId($cat);
        }
        return $out;   // [ 'Pizza' => 1 , 'Drinks' => 2 , .. ]
    }

    /* ---------------------------------------------------------------------- */
    /*  MENU ITEMS
    /* ---------------------------------------------------------------------- */
    private function seedItems(array $cat): array
    {
        $items = [
            /* ---------- PIZZA ---------- */
            ['category_id' => $cat['Pizza'], 'name' => 'Margherita Pizza', 'base_price' => 8.00, 'description' => 'Classic cheese & tomato pizza.', 'images' => json_encode(['menu/margherita-pizza.png'])],
            ['category_id' => $cat['Pizza'], 'name' => 'Pepperoni Pizza', 'base_price' => 9.00, 'description' => 'Pepperoni & mozzarella.', 'images' => json_encode(['menu/pepperoni-pizza.jpg'])],

            /* ---------- DRINKS ---------- */
            ['category_id' => $cat['Drinks'], 'name' => 'Coca Cola', 'base_price' => 2.00, 'description' => 'Chilled Coke can (330 ml)', 'images' => json_encode(['menu/coke.jpeg'])],
            ['category_id' => $cat['Drinks'], 'name' => 'Fresh Orange Juice', 'base_price' => 3.50, 'description' => 'Freshly squeezed oranges.', 'images' => json_encode(['menu/oj.png'])],

            /* ---------- BURGERS ---------- */
            ['category_id' => $cat['Burgers'], 'name' => 'Classic Beef Burger', 'base_price' => 7.00, 'description' => 'Juicy beef patty with lettuce.', 'images' => json_encode(['menu/classic-beef-burger.jpeg'])],
            ['category_id' => $cat['Burgers'], 'name' => 'Veggie Burger', 'base_price' => 6.50, 'description' => 'Grilled veggie patty.', 'images' => json_encode(['menu/veggie-burger.jpg'])],

            /* ---------- DESSERTS ---------- */
            ['category_id' => $cat['Desserts'], 'name' => 'Chocolate Brownie', 'base_price' => 4.00, 'description' => 'Warm chocolate brownie.', 'images' => json_encode(['menu/brownie.jpg'])],
            ['category_id' => $cat['Desserts'], 'name' => 'Ice Cream Sundae', 'base_price' => 5.00, 'description' => 'Vanilla ice-cream with toppings.', 'images' => json_encode(['menu/sundae.jpg'])],
        ];

        $out = [];
        foreach ($items as $i) {
            $i['is_available'] = true;
            $i['created_at'] = now();
            $i['updated_at'] = now();
            $out[$i['name']] = DB::table('menu_items')->insertGetId($i);
        }
        return $out;   // [ 'Margherita Pizza' => 1 , .. ]
    }

    /* ---------------------------------------------------------------------- */
    /*  VARIANTS
    /* ---------------------------------------------------------------------- */
    private function seedVariants(array $items): void
    {
        $map = [
            'Margherita Pizza' => [['Small', 6], ['Medium', 8], ['Large', 10]],
            'Pepperoni Pizza' => [['Medium', 9], ['Large', 12]],
            'Coca Cola' => [['Can 330ml', 2], ['Bottle 500ml', 3]],
            'Fresh Orange Juice' => [['Regular', 3.5], ['Large', 5]],
            'Classic Beef Burger' => [['Single Patty', 7], ['Double Patty', 9.5]],
            'Ice Cream Sundae' => [['Small Cup', 3], ['Large Cup', 5]],
        ];

        foreach ($map as $itemName => $variants) {
            $id = $items[$itemName];
            foreach ($variants as [$name, $price]) {
                DB::table('variants')->insert([
                    'menu_item_id' => $id,
                    'name' => $name,
                    'price' => $price,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }
    }

    /* ---------------------------------------------------------------------- */
    /*  MODIFIERS + OPTIONS
    /* ---------------------------------------------------------------------- */
    private function seedModifiers(array $items): void
    {
        $defs = [
            'Margherita Pizza' => [
                'Toppings' => [
                    'type' => 'multi_choice',
                    'required' => false,
                    'options' => [
                        ['Extra Cheese', 1],
                        ['Mushrooms', 0.5],
                        ['Olives', 0.75]
                    ]
                ],
                'Sauce' => [
                    'type' => 'single_choice',
                    'required' => true,
                    'options' => [
                        ['Tomato Sauce', 0],
                        ['BBQ Sauce', 0.5]
                    ]
                ],
            ],
            'Classic Beef Burger' => [
                'Extra Cheese' => [
                    'type' => 'multi_choice',
                    'required' => false,
                    'options' => [
                        ['Cheddar Slice', 0.8],
                        ['Swiss Cheese', 1]
                    ]
                ],
                'Patty Doneness' => [
                    'type' => 'single_choice',
                    'required' => true,
                    'options' => [
                        ['Medium', 0],
                        ['Well Done', 0]
                    ]
                ],
            ],
            'Ice Cream Sundae' => [
                'Toppings' => [
                    'type' => 'multi_choice',
                    'required' => false,
                    'options' => [
                        ['Sprinkles', 0.5],
                        ['Nuts', 0.75]
                    ]
                ],
                'Syrup Flavor' => [
                    'type' => 'single_choice',
                    'required' => true,
                    'options' => [
                        ['Chocolate Syrup', 0],
                        ['Caramel Syrup', 0.5],
                        ['Strawberry Syrup', 0.5]
                    ]
                ],
            ],
        ];

        foreach ($defs as $itemName => $modifiers) {
            $itemId = $items[$itemName];
            foreach ($modifiers as $modName => $cfg) {
                $modId = DB::table('modifiers')->insertGetId([
                    'menu_item_id' => $itemId,
                    'name' => $modName,
                    'type' => $cfg['type'],
                    'is_required' => $cfg['required'],
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
                foreach ($cfg['options'] as [$optName, $price]) {
                    DB::table('modifier_options')->insert([
                        'modifier_id' => $modId,
                        'name' => $optName,
                        'price' => $price,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }
        }
    }
}
