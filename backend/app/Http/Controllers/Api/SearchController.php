<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\MenuItem;
use Illuminate\Http\Request;

class SearchController extends Controller
{
    public function index(Request $request)
    {
        $q = $request->query('query', '');
        $q = trim($q);

        if ($q === '') {
            return response()->json([
                'success' => true,
                'data' => [
                    'products' => [],
                    'categories' => [],
                ]
            ]);
        }

        $products = MenuItem::where('name', 'LIKE', "%$q%")
            ->orWhere('description', 'LIKE', "%$q%")
            ->take(50)
            ->get(['id', 'name', 'price', 'image']);

        $categories = Category::where('name', 'LIKE', "%$q%")
            ->take(20)
            ->get(['id', 'name']);

        return response()->json([
            'success' => true,
            'data' => [
                'products' => $products,
                'categories' => $categories,
            ]
        ]);
    }
}
