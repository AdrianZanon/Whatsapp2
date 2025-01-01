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
                    Spacer(flex: 3),
                    Text(
                      'Registrarse',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(flex: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: nombreController,
                            decoration: InputDecoration(
                              labelText: 'Nombre del usuario',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: contrasenaController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'contraseña',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
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
                    Spacer(flex: 1),
                    ElevatedButton(
                      onPressed: () {
                        String nombre = nombreController.text;
                        String email = emailController.text;
                        String contrasena = contrasenaController.text;
                        String repetirContrasena =
                            repetirContrasenaController.text;

                        Future<bool> usurep(String email,
                            {String archivo = "lib/usuarios.json"}) async {
                          print("comprobando email");
                          try {
                            final file = File(archivo);
                            if (!await file.exists()) {
                              print("El archivo '$archivo' no existe.");
                              return false;
                            }

                            final contenido = await file.readAsString();
                            final List<dynamic> usuarios =
                                jsonDecode(contenido);

                            // Verificamos si el email existe en la lista
                            for (var usuario in usuarios) {
                              if (usuario["email"] == email) {
                                return true; // Email encontrado
                              }
                            }

                            return false; // Email no encontrado
                          } catch (e) {
                            print("Error al procesar el archivo: $e");
                            return false;
                          }
                        }

                        usurep(email).then((result) {
                          // Validaciones
                          if (!email.contains('@')) {
                            _showAlert(context, "El correo no es válido.");
                            return;
                          } else if (contrasena != repetirContrasena) {
                            _showAlert(
                                context, "Las contraseñas no coinciden.");
                            return;
                          } else if (result == true) {
                            _showAlert(context,
                                "el usuario ya existe con este email.");
                            return;
                          } else {
                            // Si todo es válido, crear el usuario
                            final usuario = {
                              'nombre': nombre,
                              'email': email,
                              'contrasena': contrasena,
                            };

                            final archivo = File('lib/usuarios.json');

                            // Leer los datos existentes (si el archivo no existe, usar una lista vacía)
                            List<dynamic> usuarios = [];
                            if (archivo.existsSync()) {
                              final contenido = archivo.readAsStringSync();
                              if (contenido.isNotEmpty) {
                                try {
                                  usuarios = jsonDecode(contenido);
                                } catch (e) {
                                  print('Error al leer el archivo JSON: $e');
                                }
                              }
                            }

                            // Agregar el nuevo usuario a la lista
                            usuarios.add(usuario);
                            try {
                              archivo.writeAsStringSync(jsonEncode(usuarios),
                                  mode: FileMode.write);
                              print('Usuario añadido correctamente.');
                            } catch (e) {
                              print('Error al guardar el archivo JSON: $e');
                            }

                            // Redirigir a la pantalla de inicio de sesión
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InicioSesion()),
                            );
                          }
                        });
                      },
                      child: Text('Continuar'),
                    ),
                    Spacer(flex: 2),
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
