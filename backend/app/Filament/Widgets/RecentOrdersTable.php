<?php

namespace App\Filament\Widgets;

use App\Models\Order;
use Filament\Tables;
use Filament\Widgets\TableWidget as BaseWidget;
use Filament\Tables\Columns\TextColumn;
use Illuminate\Database\Eloquent\Builder;

class RecentOrdersTable extends BaseWidget
{
    protected static ?int $sort = 4;
    protected static ?string $heading = '🕒 Recent Orders';

    protected int|string|array $columnSpan = 'full';

    protected function getTableQuery(): Builder
    {
        return Order::query()
            ->with('customer')
            ->latest()
            ->limit(10);
    }

    protected function getTableColumns(): array
    {
        return [
            TextColumn::make('order_number')
                ->label('Order #')
                ->sortable()
                ->searchable(),

            TextColumn::make('customer.name')
                ->label('Customer')
                ->placeholder('N/A')
                ->sortable()
                ->searchable(),

            TextColumn::make('total')
                ->label('Total')
                ->money('usd', true)
                ->sortable(),

            TextColumn::make('status')
                ->badge()
                ->color(fn(string $state): string => match ($state) {
                    'pending' => 'warning',
                    'confirmed' => 'info',
                    'preparing' => 'primary',
                    'delivered' => 'success',
                    'cancelled' => 'danger',
                    default => 'secondary',
                })
                ->sortable(),

            TextColumn::make('created_at')
                ->label('Date')
                ->dateTime('M d, Y h:i A')
                ->sortable(),
        ];
    }

    protected function isTablePaginationEnabled(): bool
    {
        return false;
    }
}
