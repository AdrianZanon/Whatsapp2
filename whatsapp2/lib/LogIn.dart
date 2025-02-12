import 'package:flutter/material.dart';
import 'package:whatsapp2/PprincipalInigo.dart';
import 'package:whatsapp2/PprincipalJavi.dart';
import 'package:whatsapp2/PprincipalSergi.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'SingUp.dart'; // Importar la pantalla SingUp.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatsapp 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          secondary: Colors.amber,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
              color: Colors.amber, fontSize: 20.0, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.amber),
        ),
      ),
      home: InicioSesion(),
    );
  }
}

class InicioSesion extends StatelessWidget {
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

  Future<bool> _iniciarSesion(BuildContext context) async {
    String usuarioIngresado = usuarioController.text;
    String contrasenaIngresada = contrasenaController.text;

    try {
      // Leer el archivo usuarios.json
      final archivo = File('lib/usuarios.json');
      if (!archivo.existsSync()) {
        _showError(context, 'No hay usuarios registrados.');
        return false;
      }

      // Parsear el contenido del archivo
      final contenido = archivo.readAsStringSync();
      final List<dynamic> usuarios = jsonDecode(contenido);

      // Buscar coincidencia
      bool encontrado = usuarios.any((usuario) =>
          usuario['nombre'] == usuarioIngresado &&
          usuario['contrasena'] == contrasenaIngresada);

      Map<String, dynamic>? usuarioEncontrado = usuarios.firstWhere(
        (usuario) =>
            usuario['nombre'] == usuarioIngresado &&
            usuario['contrasena'] == contrasenaIngresada,
        orElse: () => null, // Si no se encuentra, devuelve null
      );

      if (encontrado) {
        // Guardar el email en SharedPreferences
        String email = usuarioEncontrado?['email'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        print("antes");
        print(usuarioEncontrado?["email"]);
        print("despues");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inicio de sesión exitoso.')),
        );

        return true; // Indicar que el inicio de sesión fue exitoso
      } else {
        _showError(
            context, 'El nombre de usuario o la contraseña no son válidos.');
        return false; // Inicio de sesión fallido
      }
    } catch (e) {
      _showError(context, 'Ocurrió un error al leer los datos.');
      print('Error: $e');
      return false; // Manejar errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whatsapp 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Texto encima del campo "Nombre de Usuario"
            Text(
              'Iniciar Sesión',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(
                height: 32), // Espaciado entre el texto y el campo de usuario

            // Campo de texto para el nombre de usuario
            TextField(
              controller: usuarioController,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                labelStyle:
                    TextStyle(color: Colors.black), // Color de la etiqueta
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.black, // Color del borde por defecto
                    width: 2.0, // Ancho del borde
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color:
                        Colors.black, // Color del borde cuando está habilitado
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.amber, // Color del borde cuando está enfocado
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16), // Espaciado entre los campos de texto

            // Campo de texto para la contraseña
            TextField(
              controller: contrasenaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle:
                    TextStyle(color: Colors.black), // Color de la etiqueta
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.black, // Color del borde por defecto
                    width: 2.0, // Ancho del borde
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color:
                        Colors.black, // Color del borde cuando está habilitado
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.amber, // Color del borde cuando está enfocado
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(
                height:
                    16), // Espaciado entre los campos de texto y los botones

            // Botón para iniciar sesión con el texto "Whatsapp 2"
            ElevatedButton(
              onPressed: () async {
                String logueado = usuarioController.text;
                bool inicioExitoso = await _iniciarSesion(context);
                if (inicioExitoso) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        switch (logueado) {
                          case "Inigo":
                            return PrincipalInigo();
                          case "javi":
                            return PrincipalJavi();
                          case "sergi":
                            return PrincipalSergi();
                          // Agrega más casos según tus necesidades
                          default:
                            return PrincipalInigo(); // Valor por defecto
                        }
                      },
                    ),
                  );
                }
              },
              child: Text('Iniciar Sesión'), // Cambio aquí
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
