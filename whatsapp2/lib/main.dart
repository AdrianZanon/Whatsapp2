import 'package:flutter/material.dart';
import 'package:whatsapp2/LogIn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navegación',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InicioSesion(), // Pantalla inicial
    );
  }
}
