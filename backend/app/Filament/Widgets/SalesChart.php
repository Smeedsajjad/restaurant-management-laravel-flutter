<?php

namespace App\Filament\Widgets;

use App\Models\Order;
use Filament\Widgets\ChartWidget;
use Illuminate\Support\Facades\DB;

class SalesChart extends ChartWidget
{
    protected static ?int $sort = 3;
    
    protected ?string $heading = 'Sales Overview';

    protected function getData(): array
    {
        $sales = Order::select(
            DB::raw('DATE(created_at) as date'),
            DB::raw('SUM(total) as total_sales')
        )
            ->groupBy('date')
            ->orderBy('date', 'asc')
            ->take(30)
            ->get();

        return [
            'datasets' => [
                [
                    'label' => 'Revenue',
                    'data' => $sales->pluck('total_sales'),
                ],
            ],
            'labels' => $sales->pluck('date'),
        ];
    }

    protected function getType(): string
    {
        return 'bar';
    }
}
