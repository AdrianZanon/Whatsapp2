import 'package:flutter/material.dart';
import 'package:whatsapp2/Chat_Manases.dart';
import 'package:whatsapp2/Chat_Rodri.dart';
import 'package:whatsapp2/PprincipalJavi.dart';
import 'package:whatsapp2/opciones.dart';
import 'chat_Javi.dart'; // Importa la pantalla de conversación

// Definimos una clase para representar cada chat
class Chat1 {
  final String name;
  final String lastMessage;
  final String imageUrl;

  Chat1({
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
  });
}

class PrincipalInigo extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<PrincipalInigo> {
  final List<Chat1> chats = [
    Chat1(
      name: "Javi",
      lastMessage: "Pisha, no has limpiado el baño guarro",
      imageUrl: "assets/images/inigo.jpg",
    ),
    Chat1(
      name: "Manasés",
      lastMessage: "Soy el gurú del sexo, y lo sabes",
      imageUrl: "assets/images/inigo.jpg",
    ),
    Chat1(
      name: "Rodrigo",
      lastMessage: "BIP BOP",
      imageUrl: "assets/images/inigo.jpg",
    ),
  ];

  TextEditingController _controller = TextEditingController();
  List<Chat1> filteredChats = [];

  @override
  void initState() {
    super.initState();
    filteredChats = chats;
  }

  void _filterChats(String query) {
    setState(() {
      filteredChats = chats
          .where(
              (chat) => chat.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whatsapp 2'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(chats: chats),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PerfilPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterChats,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                final chat = filteredChats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(chat.imageUrl),
                  ),
                  title: Text(chat.name),
                  subtitle: Text(chat.lastMessage),
                  onTap: () {
                    if (chat.name == "Javi") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat_Javi(chat: chat),
                        ),
                      );
                    } else if (chat.name == "Rodrigo") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat_Javi(chat: chat),
                        ),
                      );
                    } else if (chat.name == "Manasés") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat_Javi(chat: chat),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<Chat1> chats;

  CustomSearchDelegate({required this.chats});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = chats
        .where((chat) => chat.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final chat = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(chat.imageUrl),
          ),
          title: Text(chat.name),
          subtitle: Text(chat.lastMessage),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat_Javi(chat: chat),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = chats
        .where((chat) => chat.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final chat = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(chat.imageUrl),
          ),
          title: Text(chat.name),
          subtitle: Text(chat.lastMessage),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat_Javi(chat: chat),
              ),
            );
          },
        );
      },
    );
  }
}
