import 'package:findoutmole/screen/login_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatefulWidget {
  
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  // bool _isPressed = false;

  // void _onTapDown(TapDownDetails details) {
  //   setState(() {
  //     _isPressed = true;
  //   });
  // }

  // void _onTapUp(TapUpDetails details) {
  //   setState(() {
  //     _isPressed = false;
  //   });
  // }

  // void _onTapCancel() {
  //   setState(() {
  //     _isPressed = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Color(0xFF4DD0E1), Color(0xFF1976D2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: TextButton(
          onPressed: () async {

            final email = widget.emailController.text.trim();
            final password = widget.passwordController.text.trim(); //Trim elimina espacios en blanco

            if (email.isEmpty || password.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Correo y contraseña requeridos')),
              );
              return;
            }

            final RegExp regex = RegExp(
              r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{6,}$',
            );

            if (password.length < 8 || !regex.hasMatch(password)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('La contraseña no cumple con los requisitos'),
                ),
              );
              return;
            }

            try {
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email,
                password: password,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Usuario registrado con éxito')),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            } on FirebaseAuthException catch (e) {
              String errorMessage = 'Error al registrar usuario';

              if (e.code == 'email-already-in-use') {
                errorMessage = 'El correo ya está registrado';
              } else if (e.code == 'invalid-email') {
                errorMessage = 'El correo no es válido';
              } else if (e.code == 'weak-password') {
                errorMessage = 'La contraseña es muy débil';
              }

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(errorMessage)));
            }
          },
          child: Text(
            'Registrar',
            style: TextStyle(
              color: Colors.white, // Color del texto del botón
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
