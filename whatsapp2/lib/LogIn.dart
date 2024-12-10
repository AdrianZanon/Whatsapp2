import 'package:flutter/material.dart';

class InicioSesion extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<InicioSesion> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  String _usernameText = ''; // Almacena el nombre de usuario
  String _passwordText =
      ''; // Almacena la contraseña // Variable para mostrar el texto ingresado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inicio de sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de texto para el nombre de usuario
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de texto para la contraseña
            TextField(
              controller: _passwordController,
              obscureText: _isObscure, // Oculta el texto de la contraseña
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                // Icono para alternar la visibilidad de la contraseña
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure =
                          !_isObscure; // Alterna la visibilidad de la contraseña
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botón para enviar los datos
            ElevatedButton(
              onPressed: () {
                // Guardamos los valores en las variables
                setState(() {
                  _usernameText = _usernameController.text;
                  _passwordText = _passwordController.text;
                });
                // Aquí puedes utilizar las variables _usernameText y _passwordText
                print('Usuario: $_usernameText');
                print('Contraseña: $_passwordText');
              },
              child: Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
