<?php

namespace App\Filament\Widgets;

use App\Models\OrderItem;
use Filament\Widgets\ChartWidget;
use Illuminate\Support\Facades\DB;

class ProductSalesChart extends ChartWidget
{
    protected static ?int $sort = 2;
    protected ?string $heading = 'Product Sales Chart';

    protected function getData(): array
    {
        $data = OrderItem::select(
            'menu_items.name',
            DB::raw('SUM(order_items.subtotal) as total_revenue')
        )
            ->join('menu_items', 'order_items.menu_item_id', '=', 'menu_items.id')
            ->groupBy('menu_items.name')
            ->orderByDesc('total_revenue')
            ->take(5)
            ->get();

        return [
            'datasets' => [
                [
                    'label' => 'Revenue by Product',
                    'data' => $data->pluck('total_revenue'),
                ],
            ],
            'labels' => $data->pluck('name'),
        ];
    }

    protected function getType(): string
    {
        return 'doughnut';
    }
}
