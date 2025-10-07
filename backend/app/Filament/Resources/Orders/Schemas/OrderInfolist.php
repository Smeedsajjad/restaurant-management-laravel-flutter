<?php

namespace App\Filament\Resources\Orders\Schemas;

use Filament\Infolists\Components\TextEntry;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class OrderInfolist
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Order details')
                    ->columns(3)
                    ->schema([
                        TextEntry::make('order_number')
                            ->label('Order #'),
                        TextEntry::make('created_at')
                            ->label('Placed on')
                            ->dateTime('d M Y  H:i'),
                        TextEntry::make('status')
                            ->badge()
                            ->color(fn(string $state): string => match ($state) {
                                'pending' => 'gray',
                                'confirmed' => 'info',
                                'preparing' => 'primary',
                                'delivered' => 'success',
                                'cancelled' => 'danger',
                            }),

                        TextEntry::make('payment_method')
                            ->label('Payment'),
                        TextEntry::make('total')
                            ->money('pkr'),
                        TextEntry::make('note')
                            ->label('Special note')
                            ->placeholder('—')
                            ->columnSpanFull(),
                    ]),

                Section::make('Delivery address')
                    ->columns(2)
                    ->schema([
                        TextEntry::make('address.label')
                            ->label('Type'),
                        TextEntry::make('address.street'),
                        TextEntry::make('address.city'),
                        TextEntry::make('address.state'),
                        TextEntry::make('address.postal_code')
                            ->label('Postal code'),
                        TextEntry::make('address.country')
                            ->default('Pakistan'),
                    ])
                    ->visible(fn($record) => $record->address),
                Section::make('Customer')
                    ->columns(2)
                    ->schema([
                        TextEntry::make('customer.name')
                            ->label('Name'),
                        TextEntry::make('customer.email')
                            ->label('Email'),
                        TextEntry::make('customer.phone')
                        ->label('Phone')
                            ->default('—'),
                    ]),
            ]);
    }
}
