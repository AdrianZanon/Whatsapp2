import 'package:flutter/material.dart';
import 'opciones.dart'; // Importa la página de perfil

// Definimos una clase para representar cada chat
class Chat {
  final String name;
  final String lastMessage;
  final String imageUrl;

  Chat({required this.name, required this.lastMessage, required this.imageUrl});
}

class PrincipalJavi extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<PrincipalJavi> {
  // Lista de chats (simulada)
  final List<Chat> chats = [
    Chat(
      name: "Iñigo",
      lastMessage: "Las buenas al cielo y las malas al Citroën",
      imageUrl: "assets/images/inigo.jpg",
    ),
    Chat(
      name: "Manasés",
      lastMessage: "Soy el gurú del sexo",
      imageUrl: "assets/images/inigo.jpg",
    ),
    Chat(
      name: "Rodrigo",
      lastMessage: "BIP BOP",
      imageUrl: "assets/images/inigo.jpg",
    ),
    Chat(
      name: "Elvira La rojas",
      lastMessage: "Hola Javi, dame leche",
      imageUrl: "assets/images/inigo.jpg",
    ),
  ];

  // Controlador de texto para la búsqueda
  TextEditingController _controller = TextEditingController();
  // Lista filtrada de chats
  List<Chat> filteredChats = [];

  @override
  void initState() {
    super.initState();
    filteredChats =
        chats; // Inicializamos la lista filtrada con todos los chats
  }

  // Filtrar chats según la búsqueda
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
          // Icono de búsqueda
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(chats),
              );
            },
          ),
          // Icono de perfil
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
          // Barra de búsqueda en la parte superior
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
          // Lista de chats filtrada
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
                    // Aquí podrías implementar la navegación a un chat si fuera necesario
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
  final List<Chat> chats;

  CustomSearchDelegate(this.chats);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Limpiar la búsqueda
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Cerrar el delegado de búsqueda
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredChats = chats
        .where((chat) => chat.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
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
            // Implementar navegación si fuera necesario
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredChats = chats
        .where((chat) => chat.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(chat.imageUrl),
          ),
          title: Text(chat.name),
          subtitle: Text(chat.lastMessage),
        );
      },
    );
  }
}
