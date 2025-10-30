<?php

namespace App\Filament\Resources\MenuItems\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Actions\ViewAction;
use Filament\Forms\Components\DatePicker;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Columns\ToggleColumn;
use Filament\Tables\Enums\FiltersLayout;
use Filament\Tables\Filters\Filter;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;
use Illuminate\Contracts\Database\Eloquent\Builder;
use Illuminate\Support\Facades\Storage;

class MenuItemsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make("name")->sortable()->searchable(),
                ImageColumn::make('images')
                    ->disk('public')
                    ->visibility('public')
                    ->imageHeight(70)
                    ->url(fn($record) => is_array($record->images) && count($record->images)
                        ? $record->images[0]
                        : null)
                    ->circular()
                    ->stacked()
                    ->limit(2)
                    ->limitedRemainingText()
                    ->wrap(),
                ToggleColumn::make("is_available")->label('Is Available'),
            ])
            ->filters([
                SelectFilter::make('is_active')
                    ->label('Status')
                    ->options([
                        '1' => 'Active',
                        '0' => 'Inactive',
                    ])
                    ->default(''),
                Filter::make('created_from')
                    ->label('Created from')
                    ->form([
                        DatePicker::make('from')
                            ->label('From')
                            ->native(false)
                            ->placeholder('dd-mm-yyyy')
                            ->displayFormat('d-m-Y')
                            ->format('Y-m-d'),
                    ])
                    ->query(function (Builder $query, array $data): Builder {
                        return $query->when(
                            $data['from'] ?? null,
                            fn(Builder $q, string $date) => $q->whereDate('created_at', '>=', $date)
                        );
                    })
                    ->indicateUsing(function (array $data): array {
                        return isset($data['from']) ? ['from' => 'From: ' . $data['from']] : [];
                    }),

                Filter::make('created_until')
                    ->label('Created until')
                    ->form([
                        DatePicker::make('until')
                            ->label('To')
                            ->native(false)
                            ->placeholder('dd-mm-yyyy')
                            ->displayFormat('d-m-Y')
                            ->format('Y-m-d'),
                    ])
                    ->query(function (Builder $query, array $data): Builder {
                        return $query->when(
                            $data['until'] ?? null,
                            fn(Builder $q, string $date) => $q->whereDate('created_at', '<=', $date)
                        );
                    })
                    ->indicateUsing(function (array $data): array {
                        return isset($data['until']) ? ['until' => 'Until: ' . $data['until']] : [];
                    }),
            ], layout: FiltersLayout::AboveContent)
            ->recordActions([
                ViewAction::make(),
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
