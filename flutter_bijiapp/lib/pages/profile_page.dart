import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../pages/login_form_page.dart';
import '../pages/edit_profile_page.dart';
import '../pages/product_form_page.dart';
import '../pages/messages_page.dart';
import '../pages/store_locations_page.dart';
import '../components/sidebar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showCallSection = false;
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ================= LOAD USER (Versi 1) =================
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService().getUserInfo();

      if (result['success'] == true && result['user'] != null) {
        setState(() {
          _currentUser = result['user'] as UserModel;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("Profile"),
        centerTitle: true,
        // Paksa gunakan tombol back, bukan hamburger menu
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadUserData),
          Builder(
            builder: (BuildContext scaffoldContext) {
              return IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Membuka Sidebar dari kiri
                  Scaffold.of(scaffoldContext).openDrawer();
                },
              );
            },
          ),
        ],
      ),
      // Menambahkan Sidebar sebagai drawer (dari kiri)
      drawer: const SideBar(),
      // Nonaktifkan drawer gesture agar tidak bentrok dengan back button
      drawerEnableOpenDragGesture: false,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
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
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _currentUser?.profilePhotoUrl != null
                              ? NetworkImage(_currentUser!.profilePhotoUrl!)
                              : null,
                          child: _currentUser?.profilePhotoUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentUser?.name ?? "-",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentUser?.address ?? "No address",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ===== ACTION ICONS =====
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
                    // 📍 LOCATION - Navigate to Store Locations
                    _circleAction(
                      icon: Icons.location_on,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StoreLocationsPage(),
                          ),
                        );
                      },
                    ),
                    // 📧 EMAIL/MESSAGE - Navigate to Messages
                    _circleAction(
                      icon: Icons.email,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MessagesPage(),
                          ),
                        );
                      },
                    ),

                    // ✏️ EDIT PROFILE
                    _circleAction(
                      icon: Icons.edit,
                      onTap: () async {
                        final updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditProfilePage(currentUser: _currentUser),
                          ),
                        );

                        if (updatedUser != null && updatedUser is UserModel) {
                          setState(() {
                            _currentUser = updatedUser;
                          });
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ===== WHITE SECTION (Tampilan Versi 2) =====
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ACTION BUTTONS
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Tambah Produk",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(
                                    74,
                                    55,
                                    73,
                                    1,
                                  ),
                                  foregroundColor: Colors.white,
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
                                    (_) => false,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // FAVOURITE MENUS SECTION
                        const Text(
                          "Favourite Menus",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Favourite Items
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

  // ================= REUSABLE WIDGETS =================
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
