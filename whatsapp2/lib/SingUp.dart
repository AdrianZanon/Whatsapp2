import 'package:flutter/material.dart';
import 'Pprincipal.dart';

class SingUp extends StatelessWidget {
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
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Nombre y apellidos',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                              height:
                                  16), // Espaciado entre los campos de texto
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'contraseña',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SingUp()),
                        );
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
