<?php

namespace App\Filament\Resources\Reviews\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class ReviewForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('user_id')
                ->relationship('user', 'name')
                ->label('Customer')
                ->required(),

                Select::make('menu_item_id')
                ->relationship('menuItem', 'name')
                ->label('Menu Item'),

                Select::make('rating')
                ->options([
                    1 => '⭐',
                    2 => '⭐⭐',
                    3 => '⭐⭐⭐',
                    4 => '⭐⭐⭐⭐',
                    5 => '⭐⭐⭐⭐⭐',
                ])
                ->label('Rating')
                ->required(),

                  Textarea::make('comment')
                ->label('Comment'),

            Toggle::make('is_approved')
                ->label('Approved'),
            ]);
    }
}
