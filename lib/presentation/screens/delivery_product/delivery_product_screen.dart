import 'dart:io';

import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:app_dev_project/presentation/screens/delivery_detail/delivery_detail_screen.dart';
import 'package:app_dev_project/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class DeliveryProductScreen extends StatefulWidget {
  static const name = 'delivery-product-screen';

  final DeliveryEntity delivery;

  const DeliveryProductScreen({
    super.key,
    required this.delivery,
    });

  @override
  State<DeliveryProductScreen> createState() => _DeliveryProductState();
}

class _DeliveryProductState extends State<DeliveryProductScreen> {
  XFile? deliveryPhoto;
  TextEditingController? deliveryobservation = TextEditingController();

  getImageFromCamera() async{
    deliveryPhoto = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                  children: [
                    IconButton(
                      onPressed: () => context.goNamed(DeliveryDetailScreen.name, extra: widget.delivery),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const Text(
                      "Entrega",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
              ),

              const SizedBox(height: 10),
              const Text("Foto de entrega", 
                style: TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.bold
                )
              ),

              InkWell(
                onTap:deliveryPhoto == null 
                  ?(){
                    getImageFromCamera();
                } : null,
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.grey[200],
                      ),
                      child:deliveryPhoto == null
                        ? Icon(Icons.camera_alt_outlined, size: 100, color: Colors.grey[400])
                        : Image.file(
                            File(deliveryPhoto!.path),
                            width: 100,
                            height: 100,
                        ), 

                    ),
                    if (deliveryPhoto != null)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.cancel, color: Theme.of(context).colorScheme.primary),
                          onPressed: () {
                            setState(() {
                              deliveryPhoto = null;
                            });
                          },
                        ),
                      ),

                  ],
                ),

              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  controller: deliveryobservation,
                  maxLength: 256,
                  maxLines: 3,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    labelText: 'Observaciones',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0), // Define el radio de los bordes
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),

        bottomNavigationBar: SizedBox(
          height: 60,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2, vertical: 5),
            child: CustomButton(
              label: "Finalizar entrega",
              fontSizeText: 17,
              color: Theme.of(context).colorScheme.primary,
              onTap: () async{
                context.go('/');
              },
            ),

          ),
        ),

      ),
    );
  }

}
