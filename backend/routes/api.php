<?php

use App\Http\Controllers\Api\AddressController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\MenuItemsController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\UserAuthController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/register', [UserAuthController::class, 'register']);
Route::post('/login', [UserAuthController::class, 'login']);
Route::post('/logout', [UserAuthController::class, 'logout'])
    ->middleware('auth:sanctum');


Route::prefix('v1')->name('api.v1.')->group(function () {
    Route::apiResource('/categories', CategoryController::class);
    Route::apiResource('/menu-items', MenuItemsController::class);
    Route::apiResource('/address', AddressController::class);
    Route::apiResource('/orders', OrderController::class);
})->middleware('auth:sanctum');
