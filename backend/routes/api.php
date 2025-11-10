<?php

use App\Http\Controllers\Api\AddressController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\MenuItemsController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\UserAuthController;
use App\Http\Resources\CartResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/* ------------------------------------------------------------------
|  Public routes  (no token)
|------------------------------------------------------------------ */
Route::post('register', [UserAuthController::class, 'register']);
Route::post('login', [UserAuthController::class, 'login']);
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');
/* ---- reviews (read only) ---- */
Route::prefix('v1')->group(function () {
    Route::get('reviews', [ReviewController::class, 'index']);
    Route::apiResource('categories', CategoryController::class);
    Route::apiResource('menu-items', MenuItemsController::class);
    Route::get('menu-items/{menuItem}/reviews', [ReviewController::class, 'getReviews']);

});

/* ------------------------------------------------------------------
|  Protected routes  (token required)
|------------------------------------------------------------------ */
Route::middleware('auth:sanctum')->group(function () {

    Route::post('logout', [UserAuthController::class, 'logout']);

    Route::prefix('v1')->as('api.v1.')->group(function () {
        Route::apiResource('addresses', AddressController::class);
        Route::apiResource('orders', OrderController::class);
        Route::apiResource('cart', \App\Http\Controllers\Api\CartController::class);
        Route::delete('cart-clear', [\App\Http\Controllers\Api\CartController::class, 'clear']);
        /* reviews (write) */
        Route::post('reviews', [ReviewController::class, 'store']);
    });
});
