<?php

use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\MenuItemsController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');


Route::prefix('v1')->name('api.v1.')->group(function () {
    Route::apiResource('/categories', CategoryController::class);
    Route::apiResource('/menu-items', MenuItemsController::class);
});
