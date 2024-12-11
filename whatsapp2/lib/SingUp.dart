import 'package:flutter/material.dart';
import 'LogIn.dart';
import 'dart:convert';
import 'dart:io';

void _showAlert(BuildContext context, String alerta) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alerta'),
        content: Text(alerta),
        actions: [
          // Botón para cerrar la alerta
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
}

class SingUp extends StatelessWidget {
  // Crear los controladores para los campos de texto
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController repetirContrasenaController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Whatsapp 2')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(
                        flex:
                            3), // Espacio para que el texto quede en el 3/4 de la pantalla
                    Text(
                      'Registrarse',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(
                        flex:
                            1), // Espacio entre el título y los campos de texto
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          // Campo para nombre y apellidos
                          TextField(
                            controller: nombreController,
                            decoration: InputDecoration(
                              labelText: 'Nombre y apellidos',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                              height:
                                  16), // Espaciado entre los campos de texto

                          // Campo para el email
                          TextField(
                            controller: emailController,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),

                          // Campo para la contraseña
                          TextField(
                            controller: contrasenaController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'contraseña',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),

                          // Campo para repetir la contraseña
                          TextField(
                            controller: repetirContrasenaController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Repetir contraseña',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(
                        flex:
                            1), // Espacio entre los campos de texto y el botón
                    ElevatedButton(
                      onPressed: () {
                        // Acceder a los valores de los controladores
                        String nombre = nombreController.text;
                        String email = emailController.text;
                        String contrasena = contrasenaController.text;
                        String repetirContrasena =
                            repetirContrasenaController.text;

                        bool error = false;
                        if (!email.contains('@')) {
                          _showAlert(context, "correo no válido");
                          error = true;
                        }
                        if (contrasena != repetirContrasena) {
                          _showAlert(context, "las contraseñas no coinciden");
                          error = true;
                        }
                        // Aquí podrías hacer validaciones o pasar los valores a la siguiente pantalla
                        print('Nombre: $nombre');
                        print('Email: $email');

                        print('Contraseña: $contrasena');
                        print('Repetir Contraseña: $repetirContrasena');

                        final usuario = {
                          'nombre': nombre,
                          'email': email,
                          'contrasena': contrasena
                        };
                        print("no hay errores");
                        final archivo = File('lib/usuarios.json');
                        archivo.writeAsString(jsonEncode(usuario));
                        // Navigator.push(
                        // context,
                        //MaterialPageRoute(
                        //  builder: (context) => InicioSesion()),
                        // );
                      },
                      child: Text('Continuar'),
                    ),
                    Spacer(flex: 2), // Espacio inferior
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
