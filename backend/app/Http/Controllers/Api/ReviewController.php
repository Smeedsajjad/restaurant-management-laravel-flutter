<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ReviewResource;
use App\Models\MenuItem;
use App\Models\Review;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ReviewController extends Controller
{
    use ApiResponse;


    public function index()
    {
        $reviews = Review::with(['user', 'menuItem'])
            ->where('is_approved', true)
            ->latest()
            ->get();

        return $this->success(ReviewResource::collection($reviews), 'Reviews fetched successfully');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'menu_item_id' => 'required|exists:menu_items,id',
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string',
        ]);

        if (!Auth::check()) {
            return $this->error('Unauthorized', 401);
        }

        $data = $validated;
        $data['user_id'] = Auth::id();
        // $data['is_approved'] = false;

        $review = Review::create($data);

        return $this->success(new ReviewResource($review), 'Review submitted successfully');
    }


    public function getReviews($menuItemId)
    {
        $menuItem = MenuItem::with('reviews')->findOrFail($menuItemId);

        return $this->success(
            ReviewResource::collection($menuItem->reviews),
            'Menu item reviews'
        );
    }
}
