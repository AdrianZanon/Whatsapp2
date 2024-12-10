import 'package:flutter/material.dart';
import 'LogIn.dart';

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
      home: Screen1(), // Pantalla inicial
    );
  }
}
