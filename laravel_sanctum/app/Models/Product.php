<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'price',
        'description',
        'category',
        'image_url',
        'user_id', 
    ];

    // Relasi tabel users dan products
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}