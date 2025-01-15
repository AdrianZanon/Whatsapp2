import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whatsapp2/PprincipalInigo.dart';

class Chat_Javi extends StatefulWidget {
  final Chat1 chat;

  Chat_Javi({required this.chat});

  @override
  _Chat_JaviState createState() => _Chat_JaviState();
}

class _Chat_JaviState extends State<Chat_Javi> {
  final TextEditingController _messageController = TextEditingController();
  final String _fileName = 'chat_data.json';
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final file = File(_fileName);

    if (await file.exists()) {
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      setState(() {
        _messages = jsonData.map((e) => Map<String, String>.from(e)).toList();
      });
    }
  }

  Future<void> _addMessage(String sender, String text) async {
    final newMessage = {"name": sender, "text": text};
    setState(() {
      _messages.add(newMessage);
    });

    final file = File(_fileName);
    if (!await file.exists()) {
      await file.create();
    }

    final jsonData = jsonEncode(_messages);
    await file.writeAsString(jsonData);
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUserMessage = message["name"] == widget.chat.name;
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message["text"]!,
          style: TextStyle(
            color: isUserMessage ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _addMessage(widget.chat.name, _messageController.text);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Define la clase Chat1
//class Chat1 {
//  final String name;
//  final String lastMessage;
//  final String imageUrl;

//  Chat1({
//    required this.name,
//    required this.lastMessage,
//    required this.imageUrl,
//  });
//}
