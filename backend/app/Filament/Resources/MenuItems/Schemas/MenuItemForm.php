<?php

namespace App\Filament\Resources\MenuItems\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Repeater;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\ToggleButtons;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class MenuItemForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([

                Section::make("Basic Info")
                    ->schema([
                        TextInput::make('name')
                            ->label('Item Name')
                            ->required(),

                        Select::make('category_id')
                            ->label('Category')
                            ->relationship(
                                name: 'category',
                                titleAttribute: 'name',
                                modifyQueryUsing: fn($query) => $query->where('is_active', true)
                            )
                            ->native(false)
                            ->required(),

                        TextInput::make('base_price')
                            ->label('Base Price')
                            ->numeric()
                            ->required()
                    ])->columns(2)->columnSpan(2),

                Section::make()
                    ->schema([
                        RichEditor::make('description')
                            ->extraAttributes([
                                'style' => 'max-height: 300px; overflow-y: auto;',
                            ])
                            ->label('Description')->columnSpan('full'),
                    ])->columns(2)->columnSpan(2),

                Section::make()
                    ->schema([
                        FileUpload::make('images')
                            ->label('Images')
                            ->image()->multiple()
                            ->reorderable()
                            ->columnSpan('full'),
                    ])->columns(2)->columnSpan(2),

                Section::make()
                    ->schema([
                        ToggleButtons::make('is_available')
                            ->label('Status')
                            ->boolean()
                            ->grouped()
                            ->default(true),
                    ])->columns(2)->columnSpan(2),

                Repeater::make('variants')
                    ->relationship('variants')
                    ->schema([
                        TextInput::make('name')->label('Variant Name'),
                        TextInput::make('price')->numeric()->label('Price'),
                    ]),

                Repeater::make('modifiers')
                    ->relationship('modifiers')
                    ->schema([
                        TextInput::make('name')->label('Modifier'),
                        Select::make('type')
                            ->options([
                                'single_choice' => 'Single Choice',
                                'multi_choice' => 'Multi Choice',
                            ]),
                        Section::make()
                            ->schema([
                                ToggleButtons::make('is_required')
                                    ->label('Required?')
                                    ->boolean()
                                    ->grouped()
                                    ->default(true),
                            ])->columns(2)->columnSpan(2),

                        Repeater::make('options')
                            ->relationship('options')
                            ->schema([
                                TextInput::make('name')->label('Option'),
                                TextInput::make('price')->numeric()->label('Extra Price'),
                            ])->columns(2)->columnSpan(2),
                    ]),

            ])->columns(2);
    }
}
