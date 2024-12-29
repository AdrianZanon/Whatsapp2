import 'package:flutter/material.dart';
import 'package:whatsapp2/Pprincipal.dart';
import 'dart:convert';
import 'dart:io';
import 'SingUp.dart'; // Importar la pantalla SingUp.dart

class InicioSesion extends StatelessWidget {
  // Controladores para los campos de texto
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  void _showError(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _iniciarSesion(BuildContext context) async {
    String usuarioIngresado = usuarioController.text;
    String contrasenaIngresada = contrasenaController.text;

    try {
      // Leer el archivo usuarios.json
      final archivo = File('lib/usuarios.json');
      if (!archivo.existsSync()) {
        _showError(context, 'No hay usuarios registrados.');
        return;
      }

      // Parsear el contenido del archivo
      final contenido = archivo.readAsStringSync();
      final List<dynamic> usuarios = jsonDecode(contenido);

      // Buscar coincidencia
      bool encontrado = usuarios.any((usuario) =>
          usuario['nombre'] == usuarioIngresado &&
          usuario['contrasena'] == contrasenaIngresada);

      if (encontrado) {
        // Si se encuentra el usuario, continuar con el inicio de sesión
        print('Inicio de sesión exitoso.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inicio de sesión exitoso.')),
        );
      } else {
        // Si no se encuentra, mostrar error
        _showError(
            context, 'El nombre de usuario o la contraseña no son válidos.');
      }
    } catch (e) {
      // Manejar errores
      _showError(context, 'Ocurrió un error al leer los datos.');
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de texto para el nombre de usuario
            TextField(
              controller: usuarioController,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16), // Espaciado entre los campos de texto
            // Campo de texto para la contraseña
            TextField(
              controller: contrasenaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
                height:
                    16), // Espaciado entre los campos de texto y los botones
            // Botón para iniciar sesión
            ElevatedButton(
              onPressed: () {
                _iniciarSesion(
                    context); // Ejecutar la lógica de inicio de sesión
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Principal()), // Navegar a la pantalla Chat
                );
              },
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 20), // Espacio entre los botones
            // Botón para crear usuario
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingUp()),
                );
              },
              child: Text('Crear Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
