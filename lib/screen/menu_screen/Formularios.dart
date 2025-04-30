import 'package:flutter/material.dart';
import 'package:findoutmole/screen/menu_screen/Perfil.dart';
import 'package:findoutmole/screen/FootBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FormulariosPage extends StatefulWidget {
  const FormulariosPage({super.key});

  @override
  _FormulariosPageState createState() => _FormulariosPageState();
}

class _FormulariosPageState extends State<FormulariosPage> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _apellidos = '';
  String _email = '';
  String _edad = '';
  String _peso = '';
  String _telefono = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario de Datos Personales')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/2.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 140),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            label: 'Nombre',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu nombre';
                              }
                              return null;
                            },
                            onSaved: (value) => _nombre = value!,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'Apellidos',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tus apellidos';
                              }
                              return null;
                            },
                            onSaved: (value) => _apellidos = value!,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'Correo Electrónico',
                            icon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu correo electrónico';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Por favor, ingresa un correo válido';
                              }
                              return null;
                            },
                            onSaved: (value) => _email = value!,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'Edad',
                            icon: Icons.cake,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu edad';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Por favor, ingresa un número válido';
                              }
                              return null;
                            },
                            onSaved: (value) => _edad = value!,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'Peso (kg)',
                            icon: Icons.fitness_center,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu peso';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Por favor, ingresa un número válido';
                              }
                              return null;
                            },
                            onSaved: (value) => _peso = value!,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'Teléfono',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu número de teléfono';
                              }
                              return null;
                            },
                            onSaved: (value) => _telefono = value!,
                          ),
                          SizedBox(height: 32),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  try {
                                    final user = FirebaseAuth.instance.currentUser;

                                    if (user != null) {
                                      final uid = user.uid;

                                      await FirebaseFirestore.instance
                                          .collection('usuarios')
                                          .doc(uid) // ✅ actualiza el documento del usuario
                                          .set({
                                        'nombre': _nombre,
                                        'apellidos': _apellidos,
                                        'email': _email,
                                        'edad': _edad,
                                        'peso': _peso,
                                        'telefono': _telefono,
                                        'fecha': DateTime.now(),
                                      });

                                      // Navega a PerfilPage sin pasar parámetros
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PerfilPage(), // ✅ Sin parámetros
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('No hay usuario autenticado')),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error al guardar los datos: $e')),
                                    );
                                  }
                                }
                              },
                              child: Text('Enviar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FooterBar(),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}