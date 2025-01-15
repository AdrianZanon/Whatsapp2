import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:whatsapp2/LogIn.dart';

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

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email =
        prefs.getString('email'); // Obtener el email del usuario logueado

    setState(() {
      _nombre = prefs.getString('nombre');
      _email = email;
      _imagePath = null; // Inicializar la ruta de la imagen
    });

    // Leer el archivo JSON y buscar la foto del usuario actual
    final archivo = File('lib/usuarios.json');
    if (archivo.existsSync()) {
      final contenido = archivo.readAsStringSync();
      List<dynamic> usuarios = jsonDecode(contenido);

      for (var usuario in usuarios) {
        if (usuario['email'] == email) {
          // Usar el email como identificador único
          _imagePath = usuario[
              'fotoPerfil']; // Obtener la foto de perfil del usuario actual
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
      // Obtener el email del usuario logueado desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email'); // Obtener el email del usuario

      if (email != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });

        // Actualizar la foto de perfil en el archivo JSON solo para el usuario actual
        final archivo = File('lib/usuarios.json');
        if (archivo.existsSync()) {
          final contenido = archivo.readAsStringSync();
          List<dynamic> usuarios = jsonDecode(contenido);

          // Encontrar al usuario actual por su email y actualizar su foto de perfil
          for (var usuario in usuarios) {
            if (usuario['email'] == email) {
              usuario['fotoPerfil'] =
                  pickedFile.path; // Guardar la nueva ruta de la imagen
              break;
            }
          }

          // Guardar los cambios en el archivo JSON
          archivo.writeAsStringSync(jsonEncode(usuarios), mode: FileMode.write);
        }
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

  // Navegar a la página de Login
  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InicioSesion()),
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
            // Imagen de perfil (si no existe, usa la imagen predeterminada)
            CircleAvatar(
              radius: 50,
              backgroundImage: _imagePath != null && _imagePath!.isNotEmpty
                  ? FileImage(File(_imagePath!))
                  : AssetImage('assets/images/default_profile.png')
                      as ImageProvider,
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _goToLogin, // Acción para ir al login
              child: Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

// Página para cambiar el nombre
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
      String? email =
          prefs.getString('email'); // Identifica al usuario por email.
      if (email != null) {
        // Intentar actualizar el archivo JSON
        final archivo = File('lib/usuarios.json');
        if (archivo.existsSync()) {
          final contenido = archivo.readAsStringSync();
          List<dynamic> usuarios = jsonDecode(contenido);

          // Busca al usuario por email
          Map<String, dynamic>? usuarioActual;
          for (var usuario in usuarios) {
            if (usuario['email'] == email) {
              usuarioActual = usuario;
              break;
            }
          }

          if (usuarioActual != null) {
            usuarios.remove(usuarioActual);

            // Crear un nuevo usuario con el nombre actualizado
            Map<String, dynamic> nuevoUsuario = Map.from(usuarioActual);
            nuevoUsuario['nombre'] = newName;

            usuarios.add(nuevoUsuario);

            archivo.writeAsStringSync(jsonEncode(usuarios),
                mode: FileMode.write);
            prefs.setString('nombre', newName);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Nombre cambiado a: $newName')),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error: Usuario no encontrado en el JSON')),
            );
          }
        }
      }
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

// Página para cambiar la contraseña
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

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');

      if (email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: No se pudo obtener el email del usuario.')),
        );
        return;
      }

      final archivo = File('lib/usuarios.json');
      if (!archivo.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: El archivo de usuarios no existe.')),
        );
        return;
      }

      final contenido = archivo.readAsStringSync();
      List<dynamic> usuarios = jsonDecode(contenido);

      Map<String, dynamic>? usuarioActual = usuarios.firstWhere(
        (usuario) => usuario['email'] == email,
        orElse: () => null,
      );

      if (usuarioActual == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error: Usuario no encontrado en el archivo JSON.')),
        );
        return;
      }

      if (usuarioActual['contrasena'] == currentPassword) {
        if (newPassword == repeatPassword && newPassword.isNotEmpty) {
          usuarioActual['contrasena'] = newPassword;
          archivo.writeAsStringSync(jsonEncode(usuarios), mode: FileMode.write);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contraseña cambiada exitosamente.')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Las contraseñas no coinciden o están vacías.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La contraseña actual es incorrecta.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar la contraseña: $e')),
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
              decoration: InputDecoration(labelText: 'Contraseña Actual'),
              obscureText: true,
            ),
            TextField(
              controller: _nuevaContrasenaController,
              decoration: InputDecoration(labelText: 'Nueva Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _repetirContrasenaController,
              decoration: InputDecoration(labelText: 'Repetir Contraseña'),
              obscureText: true,
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
