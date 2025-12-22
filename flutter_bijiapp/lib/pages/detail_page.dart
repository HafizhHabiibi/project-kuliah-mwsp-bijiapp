import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/checkout_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  String selectedSize = 'MD';
  final double price = 5.8;

  final ScrollController _scrollController = ScrollController();
  bool isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients &&
        _scrollController.offset > 20 &&
        !isScrolled) {
      setState(() => isScrolled = true);
    } else if (_scrollController.hasClients &&
        _scrollController.offset <= 20 &&
        isScrolled) {
      setState(() => isScrolled = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = price * (quantity == 0 ? 1 : quantity);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ======== BACKGROUND ========
          IgnorePointer(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/background/bg4.jpg',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black38, Colors.transparent],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container(color: Colors.white)),
              ],
            ),
          ),

          // ======== KONTEN SCROLLABLE ========
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels > 20 && !isScrolled) {
                setState(() => isScrolled = true);
              } else if (notification.metrics.pixels <= 20 && isScrolled) {
                setState(() => isScrolled = false);
              }
              return true;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.45),

                  // ======== KONTEN UTAMA ========
                  Container(
                    transform: Matrix4.translationValues(0, -35, 0),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 35,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, -6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Creamy Latte Coffee',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Rich and creamy latte blended with aromatic espresso and fresh milk. Perfect for your coffee break.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ======== PILIHAN UKURAN ========
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: ['SM', 'MD', 'LG', 'XL'].map((size) {
                            bool isSelected = size == selectedSize;
                            return GestureDetector(
                              onTap: () => setState(() => selectedSize = size),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 25,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFCFA7)
                                      : const Color(0xFFFFEBDA),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.orange
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 35),

                        // ======== HARGA & JUMLAH ========
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(CupertinoIcons.tag, size: 22),
                                const SizedBox(width: 6),
                                Text(
                                  '\$${price.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (quantity > 1) quantity--;
                                      });
                                    },
                                    child: const Icon(Icons.remove, size: 20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                    child: const Icon(Icons.add, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          '*) Dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 35),

                        // ======== TOMBOL PLACE ORDER ========
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckoutPage(),
                              ),
                            );
                          },
                          child: AnimatedScale(
                            scale: 1,
                            duration: const Duration(milliseconds: 100),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A2D46), // Ungu tua
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      fontSize: 17,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'PLACE ORDER  ',
                                        style: TextStyle(
                                          color: Colors.white, // teks putih
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '\$${totalPrice.toStringAsFixed(1)}',
                                        style: const TextStyle(
                                          color: Color(
                                            0xFFD3C1E5,
                                          ), // ungu muda lembut
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ======== APPBAR ========
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 8,
              right: 8,
            ),
            decoration: BoxDecoration(
              color: isScrolled ? Colors.white : Colors.transparent,
              boxShadow: isScrolled
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isScrolled ? Colors.black : Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Details',
                  style: TextStyle(
                    color: isScrolled ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Icon(
                  Icons.bookmark_border,
                  color: isScrolled ? Colors.black : Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
