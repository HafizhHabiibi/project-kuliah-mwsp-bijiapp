import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';

class OrderReviewsPage extends StatefulWidget {
  const OrderReviewsPage({super.key});

  @override
  State<OrderReviewsPage> createState() => _OrderReviewsPageState();
}

class _OrderReviewsPageState extends State<OrderReviewsPage> {
  double _rating = 3.0;
  bool isScrolledDown = true;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color appBarTextColor = isScrolledDown ? Colors.black : Colors.white;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Write Reviews",
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 0.5,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.more_vert, color: appBarTextColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ],
      ),
      drawer: const SideBar(),
      // 🧾 BODY
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🖼️ Product Info
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    "assets/images/menus/pic1.jpg",
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Brewed Cappuccino Latte with Creamy Milk",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Beverages",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                height: 1,
              ),
            ),

            const SizedBox(height: 10,),
            // 📝 Review Header
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                  "What do you think?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  ),
                  SizedBox(height: 6),
                  Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ⭐ Rating Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    final filled = index < _rating.round();
                    return GestureDetector(
                      onTap: () => setState(() => _rating = (index + 1).toDouble()),
                      child: Icon(
                        filled ? Icons.star_rounded : Icons.star_border_rounded,
                        color: filled ? Colors.amber : Colors.grey.shade400,
                        size: 34,
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 155),
                Text(
                  _rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 💬 TextArea
            Container(
                decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD5D5D5)),
                ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: TextField(
                controller: _reviewController,
                maxLines: 5,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write your review here",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),

      // 🟢 Submit Button (Bottom)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_reviewController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please write a review before submitting.")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Review submitted successfully!")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(74, 55, 73, 1), // warna khas BIJI
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "SUBMIT REVIEW",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
