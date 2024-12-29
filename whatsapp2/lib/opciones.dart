import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PerfilPage(),
    );
  }
}

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String? _imagePath;
  String? _nombre;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Cargar datos persistentes
  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombre = prefs.getString('nombre');
      _email = prefs.getString('email');
    });

    // Leer el archivo JSON para obtener la foto de perfil
    final archivo = File('lib/usuarios.json');
    if (archivo.existsSync()) {
      final contenido = archivo.readAsStringSync();
      List<dynamic> usuarios = jsonDecode(contenido);
      // Aquí buscar el usuario actual por su email o nombre
      for (var usuario in usuarios) {
        if (usuario['email'] == _email) {  // Usar el email como identificador único
          _imagePath = usuario['fotoPerfil'];
          break;
        }
      }
    }
    setState(() {});
  }

  // Función para seleccionar una imagen
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('imagePath', pickedFile.path);
      setState(() {
        _imagePath = pickedFile.path;
      });

      // Actualizar la foto en el JSON
      final archivo = File('lib/usuarios.json');
      if (archivo.existsSync()) {
        final contenido = archivo.readAsStringSync();
        List<dynamic> usuarios = jsonDecode(contenido);
        for (var usuario in usuarios) {
          if (usuario['email'] == _email) {  // Usar el email como identificador único
            usuario['fotoPerfil'] = pickedFile.path;
            break;
          }
        }
        archivo.writeAsStringSync(jsonEncode(usuarios), mode: FileMode.write);
      }
    }
  }

  // Navegar a la página para cambiar el nombre
  void _goToChangeName() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangeNamePage()),
    );
  }

  // Navegar a la página para cambiar la contraseña
  void _goToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen de perfil
            CircleAvatar(
              radius: 50,
              backgroundImage: _imagePath != null
                  ? FileImage(File(_imagePath!))
                  : AssetImage('assets/images/default_profile.png') as ImageProvider,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Cambiar icono'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _goToChangeName,
              child: Text('Cambiar nombre'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _goToChangePassword,
              child: Text('Cambiar contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeNamePage extends StatefulWidget {
  @override
  _ChangeNamePageState createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  TextEditingController _nombreController = TextEditingController();

  // Función para cambiar el nombre
  void _changeName() async {
    String newName = _nombreController.text;
    if (newName.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('nombre', newName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nombre cambiado a: $newName')),
      );
      Navigator.pop(context); // Volver a la página anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa un nombre válido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar Nombre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nuevo nombre'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _changeName,
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _contrasenaActualController = TextEditingController();
  TextEditingController _nuevaContrasenaController = TextEditingController();
  TextEditingController _repetirContrasenaController = TextEditingController();

  // Función para cambiar la contraseña
  void _changePassword() async {
    String currentPassword = _contrasenaActualController.text;
    String newPassword = _nuevaContrasenaController.text;
    String repeatPassword = _repetirContrasenaController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPassword = prefs.getString('contrasena');

    if (storedPassword == currentPassword) {
      if (newPassword == repeatPassword && newPassword.isNotEmpty) {
        prefs.setString('contrasena', newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña cambiada con éxito')),
        );
        Navigator.pop(context); // Volver a la página anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Las contraseñas no coinciden')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contraseña actual incorrecta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contrasenaActualController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña actual'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nuevaContrasenaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Nueva contraseña'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _repetirContrasenaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Repetir nueva contraseña'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
