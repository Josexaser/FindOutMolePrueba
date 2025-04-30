import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Authentication
import 'package:findoutmole/screen/FootBar.dart';
import 'package:findoutmole/screen/menu_screen/Formularios.dart'; // Importa la página de formularios

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtén el userId directamente desde Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mi Perfil'),
        ),
        body: Center(
          child: Text('No se encontró un usuario autenticado.'),
        ),
      );
    }

    final String userId = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navega a la página de formularios para editar los datos
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormulariosPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('usuarios').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No se encontraron datos del usuario.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Datos Guardados:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Nombre: ${userData['nombre']}', style: TextStyle(fontSize: 16)),
                Text('Apellidos: ${userData['apellidos']}', style: TextStyle(fontSize: 16)),
                Text('Correo Electrónico: ${userData['email']}', style: TextStyle(fontSize: 16)),
                Text('Edad: ${userData['edad']}', style: TextStyle(fontSize: 16)),
                Text('Peso: ${userData['peso']} kg', style: TextStyle(fontSize: 16)),
                Text('Teléfono: ${userData['telefono']}', style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: FooterBar(),
    );
  }
}