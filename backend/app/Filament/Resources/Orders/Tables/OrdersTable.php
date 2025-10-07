<?php

namespace App\Filament\Resources\Orders\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Actions\ViewAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class OrdersTable
{

    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('order_number')
                    ->label('Order #')
                    ->sortable()
                    ->searchable()
                    ->formatStateUsing(fn($state) => "#{$state}"),

                TextColumn::make('customer.name')
                    ->label('Customer')
                    ->sortable()
                    ->searchable()
                    ->placeholder('Guest'),

                TextColumn::make('address.city')
                    ->label('Address')
                    ->limit(25)
                    ->tooltip(fn($record) => $record->address?->full_address),

                TextColumn::make('total')
                    ->label('Total (Rs.)')
                    ->sortable()
                    ->money('pkr', true),

                TextColumn::make('status')
                    ->badge()
                    ->color(fn(string $state): string => match ($state) {
                        'pending' => 'gray',
                        'confirmed' => 'info',
                        'preparing' => 'primary',
                        'delivered' => 'success',
                        'cancelled' => 'danger',
                    }),
                TextColumn::make('payment_method')
                    ->label('Payment')
                    ->default('COD'),

                TextColumn::make('note')
                    ->label('Note')
                    ->limit(20)
                    ->placeholder('-'),

                TextColumn::make('created_at')
                    ->label('Ordered On')
                    ->dateTime('M d, Y h:i A')
                    ->sortable(),

            ])
            ->filters([
                //
            ])
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
