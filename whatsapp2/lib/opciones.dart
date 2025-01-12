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

  _loadPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');  // Obtener el email del usuario logueado

  setState(() {
    _nombre = prefs.getString('nombre');
    _email = email;
    _imagePath = null;  // Inicializar la ruta de la imagen
  });

  // Leer el archivo JSON y buscar la foto del usuario actual
  final archivo = File('lib/usuarios.json');
  if (archivo.existsSync()) {
    final contenido = archivo.readAsStringSync();
    List<dynamic> usuarios = jsonDecode(contenido);

    for (var usuario in usuarios) {
      if (usuario['email'] == email) {
        // Usar el email como identificador único
        _imagePath = usuario['fotoPerfil']; // Obtener la foto de perfil del usuario actual
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
            usuario['fotoPerfil'] = pickedFile.path; // Guardar la nueva ruta de la imagen
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
            // Imagen de perfil (si no existe, usa la imagen predeterminada)
              CircleAvatar(
                radius: 50,
                backgroundImage: _imagePath != null && _imagePath!.isNotEmpty
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
              print({usuarioActual?['nombre']});
              break;
            }
          }

          if (usuarioActual != null) {
            // Eliminar al usuario existente
            usuarios.remove(usuarioActual);

            // Crear un nuevo usuario con el nombre actualizado
            Map<String, dynamic> nuevoUsuario = Map.from(usuarioActual);
            nuevoUsuario['nombre'] = newName;

            // Añadir el nuevo usuario a la lista
            usuarios.add(nuevoUsuario);

            // Guardar los cambios en el archivo JSON
            archivo.writeAsStringSync(jsonEncode(usuarios),
                mode: FileMode.write);

            // Actualizar en SharedPreferences
            prefs.setString('nombre', newName);

            // Imprimir los valores actualizados
            print('Usuario actualizado: $nuevoUsuario');

            // Mostrar mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Nombre cambiado a: $newName')),
            );
            Navigator.pop(context);
          } else {
            // No se encontró el usuario en el JSON
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error: Usuario no encontrado en el JSON')),
            );
          }
        } else {
          // Archivo JSON no encontrado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: Archivo JSON no existe')),
          );
        }
      } else {
        // No se pudo obtener el email
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Email no encontrado en preferencias')),
        );
      }
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

    try {
      // Obtener el email del usuario desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');

      if (email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: No se pudo obtener el email del usuario.')),
        );
        return;
      }

      // Leer el archivo JSON
      final archivo = File('lib/usuarios.json');
      if (!archivo.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: El archivo de usuarios no existe.')),
        );
        return;
      }

      // Parsear el contenido del archivo JSON
      final contenido = archivo.readAsStringSync();
      List<dynamic> usuarios = jsonDecode(contenido);

      // Buscar al usuario actual por email
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

      // Verificar si la contraseña actual coincide
      if (usuarioActual['contrasena'] == currentPassword) {
        if (newPassword == repeatPassword && newPassword.isNotEmpty) {
          // Actualizar la contraseña en el usuario
          usuarioActual['contrasena'] = newPassword;

          // Guardar los cambios en el archivo JSON
          archivo.writeAsStringSync(jsonEncode(usuarios), mode: FileMode.write);

          // Actualizar la contraseña en SharedPreferences
          prefs.setString('contrasena', newPassword);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contraseña cambiada con éxito')),
          );
          Navigator.pop(context); // Volver a la página anterior
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Las contraseñas no coinciden o están vacías')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña actual incorrecta')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error al cambiar la contraseña.')),
      );
      print('Error: $e');
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
              decoration:
                  InputDecoration(labelText: 'Repetir nueva contraseña'),
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
