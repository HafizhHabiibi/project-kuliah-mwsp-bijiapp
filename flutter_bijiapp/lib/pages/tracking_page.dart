import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // === APP BAR ===
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
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
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                "Tracking",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
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

      // === BODY ===
      body: Stack(
        children: [
          // MAP diganti gambar statis dari assets
          Positioned.fill(
            child: Image.asset(
              "assets/images/background/map.png",
              fit: BoxFit.cover,
            ),
          ),

          // FOREGROUND CONTENT
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ====== ESTIMATED TIME BALLOON ======
              Align(
                alignment: const Alignment(-0.4, -0.25),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight,
                  children: [
                    // Card utama
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // geser kiri
                        children: [
                          Text(
                            "3–4 min",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Estimated Time",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    // Segitiga nyambung
                    Positioned(
                      top: -12,
                      right: 38,
                      child: CustomPaint(
                        size: const Size(22, 14),
                        painter: TrianglePainter(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // ====== DRIVER INFO CARD ======
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/avatar/4.jpg"),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Roy Leebauf",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "ID 2445556",
                            style: TextStyle(
                              color: Color(0xFF795548), // coklat
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/images/svg/icons/comment (1).svg",
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF795548),
                        BlendMode.srcIn,
                      ),
                      width: 26,
                      height: 26,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ====== LOCATION CARD ======
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: icons + dotted line
                    Column(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE5DAE5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF6C5B6B),
                            size: 24,
                          ),
                        ),
                        Container(
                          height: 36,
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              5,
                              (index) => Container(
                                width: 2,
                                height: 4,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF795548),
                              width: 1.5,
                            ),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.storefront_outlined,
                            color: Color(0xFF795548),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Right column (text)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sweet Corner St.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "Franklin Avenue 2263",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(40, 20),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  "Change",
                                  style: TextStyle(
                                    color: Color(0xFF795548),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Biji Coffee Shop",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Sent at 08:23 AM",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
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
            ],
          ),
        ],
      ),
    );
  }
}

/// ===== Custom Painter untuk lancip balon =====
class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
