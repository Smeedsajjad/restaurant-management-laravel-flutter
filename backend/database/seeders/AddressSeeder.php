<?php

namespace Database\Seeders;

use App\Models\Address;
use App\Models\Customer;
use App\Models\User;
use Illuminate\Database\Seeder;

class AddressSeeder extends Seeder
{
    public function run(): void
    {
        $customers = User::inRandomOrder()
            ->limit((int) (User::count() * 0.6))
            ->get();

        foreach ($customers as $customer) {
            $howMany = rand(1, 3);

            foreach (range(1, $howMany) as $i) {
                Address::create([
                    'user_id' => $customer->id,
                    'label' => fake()->randomElement(['Home', 'Work', 'Other']),
                    'street' => fake()->streetAddress(),
                    'city' => fake()->randomElement(['Lahore', 'Karachi', 'Islamabad', 'Faisalabad']),
                    'state' => fake()->randomElement(['Punjab', 'Sindh', 'KPK', 'Balochistan']),
                    'postal_code' => fake()->postcode(),
                    'country' => 'Pakistan',
                    'is_default' => $i === 1,
                ]);
            }
        }
    }
}
