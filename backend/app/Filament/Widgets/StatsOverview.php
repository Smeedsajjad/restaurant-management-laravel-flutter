<?php

namespace App\Filament\Widgets;

use App\Models\Order;
use App\Models\User;
use App\Models\MenuItem;
use App\Models\Review;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;
use Illuminate\Support\Facades\DB;

class StatsOverview extends BaseWidget
{
    protected function getStats(): array
    {
        // Last 7 days revenue trend
        $salesTrend = Order::select(
            DB::raw('DATE(created_at) as date'),
            DB::raw('SUM(total) as total')
        )
            ->whereBetween('created_at', [now()->subDays(7), now()])
            ->groupBy('date')
            ->orderBy('date', 'asc')
            ->pluck('total')
            ->toArray();

        // Last 7 days order count trend
        $ordersTrend = Order::select(
            DB::raw('DATE(created_at) as date'),
            DB::raw('COUNT(*) as total')
        )
            ->whereBetween('created_at', [now()->subDays(7), now()])
            ->groupBy('date')
            ->orderBy('date', 'asc')
            ->pluck('total')
            ->toArray();

        return [
            Stat::make('Total Orders', Order::count())
                ->description('All orders placed')
                ->icon('heroicon-o-clipboard-document-list')
                ->chart($ordersTrend)
                ->color('info'),

            Stat::make('Total Revenue', '$' . number_format(Order::sum('total'), 2))
                ->description('All-time sales')
                ->icon('heroicon-o-banknotes')
                ->chart($salesTrend)
                ->color('success'),

            Stat::make('Active Customers', User::has('orders')->count())
                ->description('Unique ordering customers')
                ->icon('heroicon-o-users')
                ->color('primary'),

            Stat::make('Menu Items', MenuItem::count())
                ->description('Available dishes')
                ->icon('heroicon-o-rectangle-stack')
                ->color('warning'),

            Stat::make('Pending Orders', Order::where('status', 'pending')->count())
                ->description('Awaiting confirmation')
                ->icon('heroicon-o-clock')
                ->color('danger'),

            Stat::make('Average Rating', number_format(Review::avg('rating'), 1) . ' / 5')
                ->description('Customer satisfaction')
                ->icon('heroicon-o-star')
                ->color('success'),
        ];
    }
}
