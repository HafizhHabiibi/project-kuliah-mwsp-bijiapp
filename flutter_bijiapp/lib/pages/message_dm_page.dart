import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';

class MessageDmPage extends StatefulWidget {
  const MessageDmPage({super.key});

  @override
  State<MessageDmPage> createState() => _MessageDmPageState();
}

class _MessageDmPageState extends State<MessageDmPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [
    {
      "text": "Your order is on my way sir. Please wait in a minutes",
      "isSent": false,
      "time": "12:58",
      "date": "Sunday, Feb 9",
    },
    {"text": "OK Bro!", "isSent": true},
    {"text": "Please call me if you already at my house", "isSent": true},
  ];

  void sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      messages.add({"text": _messageController.text.trim(), "isSent": true});
      _messageController.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // APPBAR
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.5,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 6),

                  // Profile info (image + name)
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          "assets/images/avatar/1.jpg",
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Roy Leebauf",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "ID 2445556",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
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
      ),
      drawer: const SideBar(),

      // BODY
      body: Column(
        children: [
          // 🗨️ Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final bool isSent = msg["isSent"] ?? false;
                final bool isFirst = index == 0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isFirst)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Text(
                          "${msg["date"] ?? ""}, ${msg["time"] ?? ""}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(68, 71, 79, 1),
                          ),
                        ),
                      ),
                    Align(
                      alignment:
                          isSent ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: isSent
                              ? const Color.fromRGBO(74, 55, 73, 1)
                              : Color.fromRGBO(225, 207, 167, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isSent ? 22 : 22),
                            topRight: Radius.circular(isSent ? 0 : 22),
                            bottomLeft: Radius.circular(isSent ? 22 : 0),
                            bottomRight: Radius.circular(isSent ? 22 : 22),
                          ),
                        ),
                        child: Text(
                          msg["text"],
                          style: TextStyle(
                            color: isSent ? Colors.white : Color.fromRGBO(38, 38, 38, 1),
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ✍️ MESSAGE INPUT BAR
            Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SafeArea(
              top: false,
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Text area with send icon inside the same rounded border
                Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Color(0xFFdadada),
                        width: 1.0,
                      ),
                    ),
                  child: Row(
                    children: [
                      Expanded(
                      child: TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 5,
                        decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type message...",
                        hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                      onTap: sendMessage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(229, 218, 229, 1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.all(10),
                        child:
                          const Icon(Icons.send, color: Color.fromRGBO(74, 55, 73, 1), size: 20),
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
    );
  }
}
