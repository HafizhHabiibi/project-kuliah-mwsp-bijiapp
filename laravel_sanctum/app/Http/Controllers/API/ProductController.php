<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Product;

class ProductController extends Controller
{
    /**
     * GET /products
     * List semua produk dengan info user
     */
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => Product::with('user:id,name,email')->latest()->get() // tambahkan info user
        ]);
    }

    /**
     * POST /products
     * Tambah produk - OTOMATIS SIMPAN user_id
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

        // SIMPAN user_id dari user yang login
        $validated['user_id'] = auth()->id();

        $product = Product::create($validated);

        return response()->json([
            'status' => 'success',
            'data'   => $product
        ], 201);
    }

    /**
     * PUT /products/{id}
     * Update produk - CEK OWNERSHIP
     */
    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);

        //  CEK APAKAH USER ADALAH PEMILIK
        if ($product->user_id !== auth()->id()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak memiliki akses untuk mengubah produk ini'
            ], 403);
        }

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
     * Hapus produk - CEK OWNERSHIP
     */
    public function destroy($id)
    {
        $product = Product::findOrFail($id);

        // CEK APAKAH USER ADALAH PEMILIK
        if ($product->user_id !== auth()->id()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak memiliki akses untuk menghapus produk ini'
            ], 403);
        }

        $product->delete();

        return response()->json([
            'status'  => 'success',
            'message' => 'Product deleted'
        ]);
    }
}