import 'package:flutter/material.dart';

// Definimos una clase para representar cada chat
class Chat {
  final String name;
  final String lastMessage;
  final String imageUrl;

  Chat({required this.name, required this.lastMessage, required this.imageUrl});
}

class Principal extends StatelessWidget {
  // Lista de chats (simulada)
  final List<Chat> chats = [
    Chat(
      name: "Iñigo",
      lastMessage: "Las buenas al cielo y las malas al citroen",
      imageUrl: "images/inigo.jpg", // Usa URL o imágenes locales
    ),
    Chat(
      name: "Manasés",
      lastMessage: "Soy el gurú del sexo",
      imageUrl: "https://example.com/ana.jpg",
    ),
    Chat(
      name: "Rodrigo",
      lastMessage: "BIP BOP",
      imageUrl: "https://example.com/carlos.jpg",
    ),
    // Añadir más chats simulados si lo deseas
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whatsapp 2'),
      ),
      body: ListView.builder(
        itemCount: chats.length, // Número de elementos en la lista
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(chat.imageUrl), // Imagen de perfil
            ),
            title: Text(chat.name),
            subtitle: Text(chat.lastMessage), // Último mensaje
            onTap: () {
              // Aquí podrías implementar la navegación a un chat si fuera necesario
              // Por ahora, no hacemos nada al tocar un chat
            },
          );
        },
      ),
    );
  }
}
