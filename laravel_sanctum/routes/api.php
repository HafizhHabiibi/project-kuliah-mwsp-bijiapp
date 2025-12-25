<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthenticationController;
use App\Http\Controllers\API\ProductController;

// --------------- Register & Login (PUBLIC) ----------------
Route::post('/register', [AuthenticationController::class, 'register']);
Route::post('/login', [AuthenticationController::class, 'login']);

// --------------- Protected Routes (SANCTUM) ----------------
Route::middleware('auth:sanctum')->group(function () {

    // Auth
    Route::get('/get-user', [AuthenticationController::class, 'userInfo']);
    Route::post('/logout', [AuthenticationController::class, 'logOut']);
    
    // Profile Update
    Route::put('/user/profile', [AuthenticationController::class, 'updateProfile']);

    // Products CRUD
    Route::get('/products', [ProductController::class, 'index']);
    Route::post('/products', [ProductController::class, 'store']);
    Route::put('/products/{id}', [ProductController::class, 'update']);
    Route::delete('/products/{id}', [ProductController::class, 'destroy']);
});