<?php

namespace App\Filament\Resources\Categories\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\ToggleButtons;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class CategoryForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Details')
                    ->schema([
                        TextInput::make('name')
                            ->label('Category Name')
                            ->maxLength(255)
                            ->required()
                            ->unique(),
                        Select::make('emoji')
                            ->label('Category Icon')
                            ->options(config('emojis'))
                            ->searchable()
                            ->native(false)
                            ->required()
                            ->unique(),
                        ToggleButtons::make('is_active')
                            ->label('Status')
                            ->boolean()
                            ->grouped()
                            ->default(true),
                    ])->columnSpanFull(),

            ]);

    }
}
