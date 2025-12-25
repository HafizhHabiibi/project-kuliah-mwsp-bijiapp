import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/app_config.dart';

class ProductFormPage extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final ApiService _apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  String? _selectedCategory;
  bool _isLoading = false;

  // ================= KATEGORI DROPDOWN =================
  final List<String> _categories = [
    'Beverages',
    'Brewed Coffee',
    'Blended Coffee',
  ];

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();

    // ================= ISI DATA JIKA MODE EDIT =================
    if (isEdit) {
      _nameController.text = widget.product!['name'] ?? '';
      _selectedCategory = widget.product!['category'];
      _priceController.text = widget.product!['price'].toString();
      _descController.text = widget.product!['description'] ?? '';
      _imageController.text = widget.product!['image_url'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  // ================= SUBMIT DATA =================
  Future<void> _submit() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedCategory == null) {
      _showMessage('Nama, kategori, dan harga wajib diisi');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final body = {
        'name': _nameController.text,
        'category': _selectedCategory!,
        'price': _priceController.text,
        'description': _descController.text,
        'image_url': _imageController.text,
      };

      late final response;

      if (isEdit) {
        response = await _apiService.put(
          '${AppConfig.products}/${widget.product!['id']}',
          body: body,
          needsAuth: true,
        );
      } else {
        response = await _apiService.post(
          AppConfig.products,
          body: body,
          needsAuth: true,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showMessage(
          isEdit ? 'Produk berhasil diupdate' : 'Produk berhasil ditambahkan',
        );
        Navigator.pop(context, true);
      } else if (response.statusCode == 401) {
        _showMessage('Session habis, silakan login ulang');
      } else {
        _showMessage('Gagal menyimpan produk');
      }
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4A3749),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4A3749),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Produk' : 'Tambah Produk',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER DENGAN GRADIENT =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF4A3749), Color(0xFF5E4A5D)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isEdit ? Icons.edit_note_rounded : Icons.add_circle_outline,
                    size: 60,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isEdit
                        ? 'Perbarui informasi produk'
                        : 'Tambahkan produk baru',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // ================= FORM CONTAINER =================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= NAMA PRODUK =================
                    _buildLabel('Nama Produk', Icons.coffee),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Contoh: White Cream Cappuccino',
                      icon: Icons.text_fields,
                    ),
                    const SizedBox(height: 20),

                    // ================= KATEGORI DROPDOWN =================
                    _buildLabel('Kategori', Icons.category),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedCategory,
                          hint: const Text(
                            'Pilih kategori produk',
                            style: TextStyle(color: Colors.black45),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF4A3749),
                          ),
                          items: _categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Row(
                                children: [
                                  Icon(
                                    _getCategoryIcon(category),
                                    size: 20,
                                    color: const Color(0xFF4A3749),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(category),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ================= HARGA =================
                    _buildLabel('Harga', Icons.attach_money),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _priceController,
                      hint: 'Contoh: 25000',
                      icon: Icons.monetization_on_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),

                    // ================= DESKRIPSI =================
                    _buildLabel('Deskripsi', Icons.description),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _descController,
                      hint: 'Deskripsikan produk Anda...',
                      icon: Icons.notes,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),

                    // ================= IMAGE URL =================
                    _buildLabel('Link Gambar', Icons.image),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _imageController,
                      hint: 'https://example.com/image.jpg',
                      icon: Icons.link,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // ================= PREVIEW GAMBAR =================
                    if (_imageController.text.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF4A3749).withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _imageController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image_rounded,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Gambar tidak valid',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: const Color(0xFF4A3749),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    const SizedBox(height: 30),

                    // ================= BUTTON SUBMIT =================
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A3749),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          disabledBackgroundColor: const Color(
                            0xFF4A3749,
                          ).withOpacity(0.6),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isEdit ? Icons.check_circle : Icons.save,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    isEdit ? 'UPDATE PRODUK' : 'SIMPAN PRODUK',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= WIDGET HELPER: LABEL =================
  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF4A3749)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A3749),
          ),
        ),
      ],
    );
  }

  // ================= WIDGET HELPER: TEXT FIELD =================
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 14),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF4A3749).withOpacity(0.6),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // ================= HELPER: ICON KATEGORI =================
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Beverages':
        return Icons.local_drink;
      case 'Brewed Coffee':
        return Icons.coffee;
      case 'Blended Coffee':
        return Icons.blender;
      default:
        return Icons.category;
    }
  }
}
