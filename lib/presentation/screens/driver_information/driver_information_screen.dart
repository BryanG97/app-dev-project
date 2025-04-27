
import 'package:app_dev_project/presentation/providers/delivery_provider.dart';
import 'package:app_dev_project/presentation/screens/login_screen/login_screen.dart';
import 'package:app_dev_project/presentation/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:go_router/go_router.dart';

class DriverInformationScreen extends StatefulWidget {
  static const name = 'driver-information-screen';

  const DriverInformationScreen({
    super.key,
    });

  @override
  State<DriverInformationScreen> createState() => _DriverInformationScreenState();
}

class _DriverInformationScreenState extends State<DriverInformationScreen> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, BuilderRef ref, Widget? child) {
        final data = ref.watch(deliveryProvider);
    
        return SafeArea(
          child: Scaffold(
              backgroundColor: const Color.fromARGB(251, 255, 255, 255),
              body: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [const SizedBox(height: 20),
                    
                    Container(
                      height: 300,
                      width: 300,
                      child: Dialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: Image.asset("assets/images/delivery_image.png"),
                      ),
                    ),
                    
                    const Text(
                      "Conductor",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user!.email??'',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      user!.uid??'',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                    ),

                    const SizedBox(height: 20),

                    CustomButton(
                      label: "Cerrar sesión",
                      fontSizeText: 17,
                      color: Theme.of(context).colorScheme.primary,
                      onTap: () async{
                        await FirebaseAuth.instance.signOut();

                        context.goNamed(LoginScreen.name);
                      }
                    ),

                  ],
                ),
              ),
            )
        );

      },
    );
  }

}
