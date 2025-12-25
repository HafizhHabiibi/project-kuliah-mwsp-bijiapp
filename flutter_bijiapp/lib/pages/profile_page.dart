import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../pages/login_form_page.dart';
import '../pages/edit_profile_page.dart';
import '../pages/product_form_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showCallSection = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
        foregroundColor: Colors.white, // ← WARNA PUTIH UNTUK ICON & TEXT
        elevation: 0,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // ===== AVATAR & USER INFO =====
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromRGBO(226, 201, 150, 1),
                        width: 4,
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage(
                      'assets/images/profile/avatar1.jpg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Kevin Hard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "London, England",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ===== ICON ACTIONS =====
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleAction(
                icon: Icons.phone,
                onTap: () {
                  setState(() {
                    showCallSection = !showCallSection;
                  });
                },
              ),
              _circleAction(icon: Icons.location_on, onTap: () {}),
              _circleAction(icon: Icons.email, onTap: () {}),

              // ✏️ EDIT PROFILE
              _circleAction(
                icon: Icons.edit,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 30),

          // ===== BOTTOM WHITE SECTION =====
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔥 ACTION BUTTONS BARU
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ), // ← ICON PUTIH
                          label: const Text(
                            "Tambah Produk",
                            style: TextStyle(
                              color: Colors.white,
                            ), // ← TEXT PUTIH
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(
                              74,
                              55,
                              73,
                              1,
                            ),
                            foregroundColor:
                                Colors.white, // ← WARNA PUTIH DEFAULT
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProductFormPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.logout),
                          label: const Text("Logout"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            await AuthService().logout();

                            if (!mounted) return;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Favourite Menus",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 16),

                  _favouriteItem(
                    title: "Brewed Cappuccino Latte with Creamy Milk",
                    price: "\$5.8",
                    rating: "4.0",
                    image: "assets/images/cart/pic1.jpg",
                  ),
                  _favouriteItem(
                    title: "Melted Omelette with Spicy Chilli",
                    price: "\$8.2",
                    rating: "4.0",
                    image: "assets/images/cart/pic2.jpg",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== REUSABLE WIDGETS =====
  Widget _circleAction({required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.black),
        ),
      ),
    );
  }

  Widget _favouriteItem({
    required String title,
    required String price,
    required String rating,
    required String image,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade300,
                  ),
                  child: Icon(Icons.coffee, color: Colors.grey.shade600),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text("$price   ⭐ $rating"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
