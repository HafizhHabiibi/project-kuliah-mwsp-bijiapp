<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Product;

class ProductController extends Controller
{
    /**
     * GET /products
     * List semua produk
     */
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => Product::latest()->get()
        ]);
    }

    /**
     * POST /products
     * Tambah produk
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'        => 'required|string',
            'category'    => 'required|string',
            'price'       => 'required|numeric',
            'description' => 'nullable|string',
            'image_url'   => 'nullable|url',
        ]);

        $product = Product::create($validated);

        return response()->json([
            'status' => 'success',
            'data'   => $product
        ], 201);
    }

    /**
     * PUT /products/{id}
     * Update produk
     */
    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);

        $validated = $request->validate([
            'name'        => 'required|string',
            'price'       => 'required|numeric',
            'description' => 'nullable|string',
            'category'    => 'required|string',
            'image_url'   => 'nullable|url',
        ]);

        $product->update($validated);

        return response()->json([
            'status' => 'success',
            'data'   => $product
        ]);
    }

    /**
     * DELETE /products/{id}
     * Hapus produk
     */
    public function destroy($id)
    {
        Product::findOrFail($id)->delete();

        return response()->json([
            'status'  => 'success',
            'message' => 'Product deleted'
        ]);
    }
}
