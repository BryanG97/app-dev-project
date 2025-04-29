import 'package:app_dev_project/config/theme/app_colors.dart';
import 'package:app_dev_project/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_dev_project/presentation/widgets/custom_toast.dart';
import 'package:app_dev_project/presentation/widgets/custom_button.dart';
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
      //backgroundColor: Color.fromARGB(54, 99, 242, 242),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: const AssetImage("assets/images/login_image.png"),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Green Route',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0), // verde tipo Uber Eats
                shadows: [
                  Shadow(
                    blurRadius: 5,
                    color: Colors.black26,
                    offset: Offset(2, 2),
                  )
                ]
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            CustomButton(
              label: "Cerrar sesión",
              fontSizeText: 17,
              color: Theme.of(context).colorScheme.primary,
              onTap:() async{
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
              }
            ),

          ],
        ),
      ),
    );
  }
}
