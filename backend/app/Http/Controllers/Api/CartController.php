<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\CartResource;
use App\Models\Cart;
use App\Models\MenuItem;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CartController extends Controller
{
    use ApiResponse;

    public function index(Request $request)
    {
        $cartItems = Cart::with('menuItem')
            ->where('user_id', $request->user()->id)
            ->get();

        return $this->success(CartResource::collection($cartItems), 'Cart items fetched successfully');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'menu_item_id' => 'required|exists:menu_items,id',
            'quantity' => 'required|integer|min:1',
        ]);

        $menuItem = MenuItem::findOrFail($validated['menu_item_id']);
        $price = $menuItem->base_price;
        $subtotal = $price * $validated['quantity'];

        $cartItem = Cart::updateOrCreate(
            [
                'user_id' => Auth::id(),
                'menu_item_id' => $menuItem->id,
            ],
            [
                'quantity' => $validated['quantity'],
                'price' => $price,
                'subtotal' => $subtotal,
            ]
        );

        return $this->success(new CartResource($cartItem), 'Item added to cart successfully');
    }

    public function update(Request $request, Cart $cart)
    {
        if ($cart->user_id !== $request->user()->id) {
            return $this->unauthorized('You do not own this cart item');
        }

        $validated = $request->validate([
            'quantity' => 'required|integer|min:1',
        ]);

        $cart->update([
            'quantity' => $validated['quantity'],
            'subtotal' => $cart->price * $validated['quantity'],
        ]);

        return $this->success(new CartResource($cart), 'Cart item updated successfully');
    }

    public function destroy(Request $request, Cart $cart)
    {
        if ($cart->user_id !== $request->user()->id) {
            return $this->unauthorized('You do not own this cart item');
        }

        $cart->delete();

        return $this->success(null, 'Item removed from cart successfully');
    }

    public function clear(Request $request)
    {
        Cart::where('user_id', $request->user()->id)->delete();

        return $this->success(null, 'Cart cleared successfully');
    }
}
