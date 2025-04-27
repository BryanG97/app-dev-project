import 'package:app_dev_project/config/theme/app_colors.dart';
import 'package:app_dev_project/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_dev_project/presentation/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  static const name = 'login-screen';

  const LoginScreen({
    super.key
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      context.goNamed(CustomBottomNavigationBar.name);
    } on FirebaseAuthException catch (e) {
      var message= "";
      if(e.code == 'invalid-email'){
        message = "Correo electrónico inválido";
      }
      if(e.code == 'invalid-credential'){
        message = "Correo o ontraseña inválidos";
      }
      
      
      customToast(
        seconds: 3,
        context: context,
        icon: Icons.warning_amber_rounded,
        width: MediaQuery.of(context).size.width * 0.6,
        color: AppColors.warningColor,
        text: message,
        radius: 20,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:() async{
                if( emailController.text.trim() == "" ){
                  customToast(
                    seconds: 3,
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    width: MediaQuery.of(context).size.width * 0.6,
                    color: AppColors.warningColor,
                    text: 'Ingrese un correo electrónico',
                    radius: 20,
                  );
                  return;
                }
                if( passwordController.text.trim() == "" ){
                  customToast(
                    seconds: 3,
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    width: MediaQuery.of(context).size.width * 0.6,
                    color: AppColors.warningColor,
                    text: 'Ingrese contraseña',
                    radius: 20,
                  );
                  return;
                }
                  
                _login();
              } ,
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
