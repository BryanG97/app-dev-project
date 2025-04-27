

import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:app_dev_project/presentation/providers/delivery_provider.dart';
import 'package:app_dev_project/presentation/screens/delivery_detail/delivery_detail_screen.dart';
import 'package:app_dev_project/presentation/widgets/loandig_delivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:go_router/go_router.dart';

class ViewDeliveryScreen extends StatefulWidget {
  static const name = 'view-delivery-screen';

  final DeliveryEntity delivery;

  const ViewDeliveryScreen({
    super.key,
    required this.delivery,
    });

  @override
  State<ViewDeliveryScreen> createState() => _ViewDeliveryState();
}

class _ViewDeliveryState extends State<ViewDeliveryScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, BuilderRef ref, Widget? child) {
        final data = ref.watch(deliveryProvider);

        return SafeArea(
          child: data.getLoading
          ? const Scaffold(
            backgroundColor:  Color.fromARGB(251, 255, 255, 255),
            body: Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DeliveryGifLoadingDialog(),
                  Text(
                    "Cargando contenido de entrega...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
          : Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            body: Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                        children: [
                          IconButton(
                            onPressed: () => context.goNamed(DeliveryDetailScreen.name, extra: widget.delivery),
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          const Text(
                            "Información entrega",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Container()),
                          Image.asset("assets/images/delivery_image.png", height: 40, width: 40),
                        ],
                    ),

                    const SizedBox(height: 10),
                    const Text("Foto de evidencia", 
                      style: TextStyle(
                        fontSize: 25, 
                        fontWeight: FontWeight.bold,
                      )
                    ),

                    const SizedBox(height: 5),
                    Image.network(
                      widget.delivery.deliveryImageUrl!,
                      fit: BoxFit.cover,
                      width: 400,
                      height: 400,
                    ),

                    const Divider(thickness: 2),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Observación:",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.delivery.deliveryObservation??'N/A',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        );

      }
    );

  }
}
