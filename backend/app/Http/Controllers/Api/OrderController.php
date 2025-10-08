<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\OrderResource;
use App\Models\MenuItem;
use App\Models\Order;
use App\Models\OrderItem;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class OrderController extends Controller
{
    use ApiResponse;
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $user = $request->user();

        $orders = Order::with(['items.menuItem', 'address'])
            ->where('user_id', $user->id)
            ->latest()
            ->get();

        $addresses = $user->addresses; // fetch all addresses

        return $this->success([
            'orders' => OrderResource::collection($orders),
            'addresses' => $addresses,
        ], 'Orders and addresses fetched successfully');
    }


    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'address_id' => [
                'required',
                Rule::exists('addresses', 'id')->where('user_id', $request->user()->id),
            ],
            'items' => 'required|array|min:1',
            'items.*.menu_item_id' => 'required|exists:menu_items,id',
            'items.*.quantity' => 'required|integer|min:1',
            'note' => 'nullable|string',
        ]);


        $userId = $request->user()->id;

        return DB::transaction(function () use ($validated, $userId) {
            $subtotal = 0;
            foreach ($validated['items'] as $item) {
                $menuItem = MenuItem::find($item['menu_item_id']);
                $subtotal += $menuItem->base_price * $item['quantity'];
            }

            $tax = $subtotal * 0.05;
            $total = $subtotal + $tax;

            $order = Order::create([
                'user_id' => $userId,
                'address_id' => $validated['address_id'],
                'order_number' => strtoupper(Str::random(8)),
                'subtotal' => $subtotal,
                'tax' => $tax,
                'total' => $total,
                'payment_method' => 'COD',
                'note' => $validated['note'] ?? null,
            ]);

            foreach ($validated['items'] as $item) {
                $menuItem = MenuItem::find($item['menu_item_id']);
                OrderItem::create([
                    'order_id' => $order->id,
                    'menu_item_id' => $menuItem->id,
                    'quantity' => $item['quantity'],
                    'price' => $menuItem->base_price,
                    'subtotal' => $menuItem->base_price * $item['quantity'],
                ]);
            }

            return $this->created(new OrderResource($order->load(['items.menuItem', 'address'])), 'Order placed successfully');
        });
    }

    /**
     * Display the specified resource.
     */
    public function show(Request $request, Order $order)
    {
        if ($order->user_id !== $request->user()->id) {
            return $this->unauthorized('You do not own this order');
        }

        return $this->success(new OrderResource($order->load(['items.menuItem', 'address'])), 'Order details');
    }


    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Order $order)
    {
        $validated = $request->validate([
            'status' => 'sometimes|in:pending,confirmed,preparing,delivered,cancelled',
            'note' => 'nullable|string',
        ]);

        $order->update($validated);

        return $this->success(new OrderResource($order->load(['items.menuItem', 'address'])), 'Order updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Order $order)
    {
        $order->delete();

        return $this->success(null, 'Order deleted successfully');
    }
}
