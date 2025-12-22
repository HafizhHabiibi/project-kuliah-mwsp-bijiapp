import 'package:flutter/material.dart';

class ElementPage extends StatelessWidget {
  const ElementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔸 Urutan normal (kiri ke kanan / atas ke bawah)
    final List<String> components = [
      'Accordion',
      'Action Sheet',
      'Appbar',
      'Autocomplete',
      'Badge',
      'Buttons',
      'Calendar / Date Picker',
      'Cards',
      'Cards Expandable',
      'Checkbox',
      'Chips / Tags',
      'Color Picker',
      'Contacts List',
      'Content Block',
      'Data Table',
      'Dialog',
      'Elevation',
      'FAB',
      'FAB Morph',
      'Form Storage',
      'Gauge',
      'Grid / Layout Grid',
      'Icons',
      'Infinite Scroll',
      'Inputs',
      'Lazy Load',
      'List View',
      'List Index',
      'Login Screen',
      'Menu',
      'Messages',
      'Navbar',
      'Notifications',
      'Panel / Side Panels',
      'Photo Browser',
      'Picker',
      'Popover',
      'Popup',
      'Preloader',
      'Progress Bar',
      'Pull To Refresh',
      'Radio',
      'Range Slider',
      'Searchbar',
      'Searchbar Expandable',
      'Sheet Modal',
      'Skeleton (Ghost) Layouts',
      'Smart Select',
      'Sortable List',
      'Stepper',
      'Subnavbar',
      'Swipeout (Swipe To Delete)',
      'Swiper Slider',
      'Tabs',
      'Text Editor',
      'Timeline',
      'Toast',
      'Toggle',
      'Toolbar & Tabbar',
      'Tooltip',
      'Treeview',
      'Virtual List',
      'vi - Mobile Video SSP',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Framework7",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          // 🔹 Header pertama
          ListTile(
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/images/f7-icon.png'),
            ),
            title: const Text(
              "About Framework7",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Text(
              "Components",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),

          // 🔸 List komponen normal kiri ke kanan
          ...components.map((name) {
            bool isLast = name == 'vi - Mobile Video SSP';
            return ListTile(
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: isLast
                      ? Colors.yellow.shade700
                      : Colors.deepPurple.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  isLast
                      ? 'assets/images/vi-icon.png'
                      : 'assets/images/f7-icon.png',
                ),
              ),
              title: Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
            );
          }).toList(),
        ],
      ),
    );
  }
}
