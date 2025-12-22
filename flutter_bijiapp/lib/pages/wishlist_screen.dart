import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, String>> filteredItems = [];

  final List<Map<String, String>> wishlistItems = [
    {
      "image": "assets/images/menus/pic1.jpg",
      "name": "Brown Hand Watch",
      "variant": "Variant : White Stripes",
      "price": "\$69.4",
    },
    {
      "image": "assets/images/menus/pic2.jpg",
      "name": "Possil Leather Watch",
      "variant": "Variant : White Stripes",
      "price": "\$69.4",
    },
    {
      "image": "assets/images/menus/pic3.jpg",
      "name": "Super Red Naiki Shoes",
      "variant": "Variant : White Stripes",
      "price": "\$69.4",
    },
    {
      "image": "assets/images/menus/pic4.jpg",
      "name": "Brown Hand Watch",
      "variant": "Variant : White Stripes",
      "price": "\$69.4",
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(wishlistItems);
    _searchController.addListener(_filterSearch);
  }

  void _filterSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = wishlistItems
          .where(
            (item) =>
                item["name"]!.toLowerCase().contains(query) ||
                item["variant"]!.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _isSearching = false;
      filteredItems = List.from(wishlistItems);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Overlay hanya tampil saat sedang fokus mencari dan field masih kosong
    final bool showOverlay = _isSearching && _searchController.text.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Wishlist',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black87),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
          ],
      ),
      drawer: const SideBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Stack(
            children: [
              /// ======= Konten utama =======
              Column(
                children: [
                  /// 🔍 Search Bar
                  WishlistSearchBar(
                    controller: _searchController,
                    isSearching: _isSearching,
                    onFocusChange: (focus) =>
                        setState(() => _isSearching = focus),
                    onClear: _clearSearch,
                  ),
                  const SizedBox(height: 20),

                  /// 🧾 Daftar konten (overlay hanya di area ini)
                  Expanded(
                    child: Stack(
                      children: [
                        // List atau pesan kosong
                        filteredItems.isEmpty
                            ? const Center(
                                child: Text(
                                  "No items found",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredItems.length,
                                itemBuilder: (context, index) {
                                  final item = filteredItems[index];
                                  return WishlistItemCard(item: item);
                                },
                              ),

                        // Overlay transparan yang hanya menutupi area daftar
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: showOverlay ? 0.5 : 0.0,
                          child: IgnorePointer(
                            // Mengabaikan input hanya saat overlay TAMPIL (showOverlay == true)
                            ignoring: !showOverlay,
                            child: GestureDetector(
                              onTap: _clearSearch,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 🔹 WIDGET: Search Bar
//
class WishlistSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSearching;
  final Function(bool) onFocusChange;
  final VoidCallback onClear;

  const WishlistSearchBar({
    super.key,
    required this.controller,
    required this.isSearching,
    required this.onFocusChange,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Focus(
              onFocusChange: (focus) => onFocusChange(focus),
              child: TextField(
                controller: controller,
                cursorColor: const Color(0xFF4A3749),
                decoration: InputDecoration(
                  hintText: 'Search Here',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          if (isSearching)
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}

//
// 🔹 WIDGET: Item Card
//
class WishlistItemCard extends StatelessWidget {
  final Map<String, String> item;

  const WishlistItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            item["image"]!,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item["name"]!,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item["variant"]!,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Text(
              item["price"]!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.favorite, color: Color(0xFF4A3749)),
      ),
    );
  }
}
