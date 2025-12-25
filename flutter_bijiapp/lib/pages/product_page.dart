import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/app_config.dart';
import 'product_form_page.dart';
import 'login_form_page.dart';
import 'detail_page.dart';

class ProductPage extends StatefulWidget {
  final String categoryName;

  const ProductPage({super.key, this.categoryName = 'All'});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;

  List<String> categories = [
    "All",
    "Beverages",
    "Brewed Coffee",
    "Blended Coffee",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    fetchProducts();
  }

  // ================= FETCH PRODUCTS =================
  Future<void> fetchProducts() async {
    setState(() => isLoading = true);

    try {
      final response = await _apiService.get(
        AppConfig.products,
        needsAuth: true,
      );

      final data = _apiService.parseResponse(response);

      if (response.statusCode == 200) {
        setState(() {
          products = data['data'];
          filteredProducts = List.from(products);
        });
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showMessage('Gagal mengambil data produk');
      }
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= DELETE PRODUCT =================
  Future<void> deleteProduct(int id) async {
    try {
      final response = await _apiService.delete(
        '${AppConfig.products}/$id',
        needsAuth: true,
      );

      if (response.statusCode == 200) {
        _showMessage('Produk berhasil dihapus');
        fetchProducts();
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showMessage('Gagal menghapus produk');
      }
    } catch (e) {
      _showMessage(e.toString());
    }
  }

  // ================= SEARCH PRODUCT =================
  void _searchProduct(String query) {
    setState(() {
      filteredProducts = products
          .where(
            (item) => item['name'].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  // ================= TOKEN EXPIRED =================
  void _handleUnauthorized() async {
    await _apiService.removeToken();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                  const Text(
                    "Products",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductFormPage(),
                        ),
                      );
                      if (result == true) {
                        fetchProducts();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFF4A3749),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ===== SEARCH BAR =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: _searchProduct,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.black54),
                          hintText: "Search here...",
                          hintStyle: TextStyle(color: Colors.black45),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      color: Color(0xFF4A3749),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== TAB BAR =====
            Container(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF4A3749),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                tabs: categories.map((e) => Tab(text: e)).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // ===== PRODUCT GRID =====
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                  ? const Center(child: Text('Belum ada produk'))
                  : RefreshIndicator(
                      onRefresh: fetchProducts,
                      child: TabBarView(
                        controller: _tabController,
                        children: categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              itemCount: filteredProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.73,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];

                                // ==== CARD PRODUK YANG BISA DIKLIK ====
                                return InkWell(
                                  borderRadius: BorderRadius.circular(18),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DetailPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ===== GAMBAR PRODUK =====
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(18),
                                                  ),
                                              child:
                                                  product['image_url'] !=
                                                          null &&
                                                      product['image_url'] != ''
                                                  ? Image.network(
                                                      product['image_url'],
                                                      height: 120,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Container(
                                                              height: 120,
                                                              color: Colors
                                                                  .grey[200],
                                                              child: const Icon(
                                                                Icons.coffee,
                                                                size: 50,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            );
                                                          },
                                                    )
                                                  : Container(
                                                      height: 120,
                                                      color: Colors.grey[200],
                                                      child: const Icon(
                                                        Icons.coffee,
                                                        size: 50,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                            ),
                                            // ===== TOMBOL EDIT & DELETE =====
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Row(
                                                children: [
                                                  // TOMBOL EDIT
                                                  InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          50,
                                                        ),
                                                    onTap: () async {
                                                      final result =
                                                          await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  ProductFormPage(
                                                                    product:
                                                                        product,
                                                                  ),
                                                            ),
                                                          );
                                                      if (result == true) {
                                                        fetchProducts();
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 32,
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                  0.15,
                                                                ),
                                                            blurRadius: 6,
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  3,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: const Icon(
                                                        Icons.edit,
                                                        color: Color(
                                                          0xFF4A3749,
                                                        ),
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  // TOMBOL DELETE
                                                  InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          50,
                                                        ),
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) => AlertDialog(
                                                          title: const Text(
                                                            'Hapus Produk',
                                                          ),
                                                          content: const Text(
                                                            'Yakin ingin menghapus produk ini?',
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),
                                                              child: const Text(
                                                                'Batal',
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                                deleteProduct(
                                                                  product['id'],
                                                                );
                                                              },
                                                              child: const Text(
                                                                'Hapus',
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 32,
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                  0.15,
                                                                ),
                                                            blurRadius: 6,
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  3,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // ===== DESKRIPSI PRODUK =====
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product['name'] ??
                                                    'Nama Produk',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                product['category'] ??
                                                    'Tanpa kategori',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.local_offer_outlined,
                                                    color: Colors.black54,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "Rp ${double.tryParse(product['price'].toString())?.toStringAsFixed(0) ?? '0'}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF4A3749),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
