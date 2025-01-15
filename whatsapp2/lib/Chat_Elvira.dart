import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whatsapp2/PprincipalInigo.dart';
//import 'package:whatsapp2/PprincipalJavi.dart';

class Chat_Elvira extends StatefulWidget {
  final Chat1 chat;

  Chat_Elvira({required this.chat});

  @override
  _Chat_ElviraState createState() => _Chat_ElviraState();
}

class _Chat_ElviraState extends State<Chat_Elvira> {
  final TextEditingController _messageController = TextEditingController();
  final String _fileName = 'chat_data_elvira.json';
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
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
