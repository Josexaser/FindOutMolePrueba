import 'package:findoutmole/screen/register_screen/cuentraPrevia.dart';
// import 'package:findoutmole/screen/register_screen/nombre_de_usuario.dart';
import 'package:flutter/material.dart';
//import 'package:findoutmole/screen/register_screen/confirmar_Contraseña.dart';
import 'package:findoutmole/screen/register_screen/contraseña.dart';
import 'package:findoutmole/screen/register_screen/email.dart';
//import 'package:findoutmole/screen/register_screen/nombre_de_usuario.dart';
import 'package:findoutmole/screen/register_screen/registerButton.dart';
import 'package:findoutmole/screen/register_screen/textoInicial.dart';
import 'package:findoutmole/screen/FootBar.dart'; // Importa el pie de página

class RegisterPage extends StatelessWidget {



  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController passController= TextEditingController();
    final TextEditingController emailController = TextEditingController();

    // Obtén las dimensiones de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/2.png', fit: BoxFit.cover),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    Image.asset('assets/images/lupaconojo.png', height: screenHeight * 0.15),
                    SizedBox(height: screenHeight * 0.03),
                    const TextoInicial(),
                    SizedBox(height: screenHeight * 0.03),
                    //const NombreDeUsuario(),
                    SizedBox(height: screenHeight * 0.03),
                    EmailField(controller: emailController ),
                    SizedBox(height: screenHeight * 0.03),
                    PasswordField(controller: passController), // Pasa el controller aquí
                    SizedBox(height: screenHeight * 0.03),
                    // ConfirmPasswordField(
                    // passwordController: passController), // Pasa el controller aquí
                    SizedBox(height: screenHeight * 0.03),
                    RegisterButton(
                      passwordController: passController,
                      emailController: emailController,),
                    SizedBox(height: screenHeight * 0.03),
                    const CuentaExiste(),
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
}
