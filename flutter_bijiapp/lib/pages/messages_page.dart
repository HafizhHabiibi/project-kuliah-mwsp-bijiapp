import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/message_dm_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final List<Map<String, dynamic>> messages = [
    {
      "name": "Sam Verdinand",
      "message": "OK. Lorem ipsum dolor sect...",
      "time": "2M AGO",
      "image": "assets/images/avatar/1.jpg",
      "online": true
    },
    {
      "name": "Freddie Ronan",
      "message": "OK. Lorem ipsum dolor sect...",
      "time": "2:00 PM",
      "image": "assets/images/avatar/2.jpg",
      "online": true
    },
    {
      "name": "Ethan Jacoby",
      "message": "OK. Lorem ipsum dolor sect...",
      "time": "5:00 PM",
      "image": "assets/images/avatar/3.jpg",
      "online": true
    },
    {
      "name": "Alfie Mason",
      "message": "OK. Lorem ipsum dolor sect...",
      "time": "3:00 AM",
      "image": "assets/images/avatar/4.jpg",
      "online": false
    },
    {
      "name": "Archie Parker",
      "message": "OK. Lorem ipsum dolor sect...",
      "time": "TOADY",
      "image": "assets/images/avatar/5.jpg",
      "online": false
    },
    {
      "name": "Isaac Banford",
      "message": "OK. Lorem ipsum dolor sect...",
      "time": "04/24/2021",
      "image": "assets/images/avatar/2.jpg",
      "online": false
    },
    {
      "name": "Henry Hunter",
      "message": "OK. Lorem ipsum dolor sect...",
      "time": "04/23/2021",
      "image": "assets/images/avatar/3.jpg",
      "online": false
    },
    {
      "name": "Harry Parker",
      "message": "OK. Lorem ipsum dolor sect...",
      "time": "04/22/2021",
      "image": "assets/images/avatar/4.jpg",
      "online": false
    },
    {
      "name": "George Carson",
      "message": "OK. Lorem ipsum dolor sect...",
      "time": "04/21/2021",
      "image": "assets/images/avatar/5.jpg",
      "online": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredMessages = messages
        .where((msg) => msg['name']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Messages List",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/svg/icons/profile_icon.svg',
              width: 24,
              height: 24,
              color: const Color(0xFF222222),
            ),
            onPressed: () {},
          ),
        ],
      ),

      // BODY
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 14, 30, 8),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFEBEBEB)),
                ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                children: [
                  SvgPicture.asset(
                      'assets/images/svg/icons/search_icon.svg',
                      width: 22,
                      height: 22,
                      color: Colors.grey,
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          searchQuery = val;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Find food here...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => searchQuery = '');
                      },
                    )
                ],
              ),
            ),
          ),

          // 🗂️ Message List
          Expanded(
            child: filteredMessages.isEmpty
                ? const Center(
                    child: Text(
                      "Nothing found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: filteredMessages.length,
                    itemBuilder: (context, index) {
                      final msg = filteredMessages[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MessageDmPage()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 🖼️ Avatar
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.asset(
                                      msg['image'],
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (msg['online'])
                                    Positioned(
                                      bottom: 3,
                                      right: 4,
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.8,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),

                              // 💬 Message Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          msg['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          msg['time'],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      msg['message'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
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
          ),
        ],
      ),
    );
  }
}
