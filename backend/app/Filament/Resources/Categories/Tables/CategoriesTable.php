<?php

namespace App\Filament\Resources\Categories\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Actions\ViewAction;
use Filament\Tables\Enums\FiltersLayout;
use Illuminate\Database\Eloquent\Builder;
use Filament\Forms\Components\DatePicker;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Columns\ToggleColumn;
use Filament\Tables\Filters\Filter;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class CategoriesTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->reorderable("position")
            ->columns([
                TextColumn::make("emoji")->label("Icon") ->extraAttributes(['style' => 'font-size: 2rem;']),
                TextColumn::make("name")->sortable()->searchable(),
                ToggleColumn::make("is_active")->label('Is Active'),
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
                EditAction::make()->modalWidth('lg')->slideOver(),
                DeleteAction::make()
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
