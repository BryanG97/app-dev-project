import 'dart:io';

import 'package:app_dev_project/config/theme/app_colors.dart';
import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:app_dev_project/presentation/providers/delivery_provider.dart';
import 'package:app_dev_project/presentation/screens/delivery_detail/delivery_detail_screen.dart';
import 'package:app_dev_project/presentation/screens/multiple_delivery/multiple_delivery_screen.dart';
import 'package:app_dev_project/presentation/widgets/custom_button.dart';
import 'package:app_dev_project/presentation/widgets/custom_toast.dart';
import 'package:app_dev_project/presentation/widgets/loandig_delivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
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
  TextEditingController? deliveryObservation = TextEditingController();

  int? selectOption;
  List<String> items = [
    "Entregado",
    "No entregado",
  ];

  @override
  void initState() {
    super.initState();

    // Inicializa observaciones
    deliveryObservation = TextEditingController(
      text: widget.delivery.deliveryObservation ?? '',
    );

    // Inicializa radio button según el estado
    selectOption = widget.delivery.status == "noDelivered" ? 1 : 0;
  }

  getImageFromCamera() async{
    deliveryPhoto = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      
    });
  }

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
                    "Guardando los datos,\nespere un momento por favor..",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
          :Scaffold(
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
                            "Entrega",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Container()),
                          Image.asset("assets/images/delivery_image.png", height: 40, width: 40),
                        ],
                    ),

                    SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Card(
                                color: index == selectOption
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: RadioListTile(
                                  value: index,
                                  groupValue: selectOption,
                                  activeColor: Colors.white,
                                  onChanged: widget.delivery.status != "pending"
                                  ? null
                                  : (value) {
                                    setState(() {
                                      selectOption = index;
                                    });
                                  },
                                  title: Text(
                                    items[index],
                                    style: TextStyle(
                                      color: index == selectOption ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                            
                        },
                      ),
                    ),

                    const Divider(thickness: 2),
                    const SizedBox(height: 10),
                    const Text("Foto de evidencia", 
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
                            height: 220,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.grey[200],
                            ),
                            child:deliveryPhoto == null
                              ? Icon(Icons.camera_alt_outlined, size: 100, color: Colors.grey[400])
                              : Image.file(
                                  File(deliveryPhoto!.path),
                                  width: 200,
                                  height: 200,
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

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        enabled: widget.delivery.status == "pending",
                        controller: deliveryObservation,
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
            ),

            bottomNavigationBar: 
            widget.delivery.status == "pending"
            ? SizedBox(
              height: 60,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2, vertical: 5),
                child: CustomButton(
                  label: "Finalizar entrega",
                  fontSizeText: 17,
                  color: Theme.of(context).colorScheme.primary,
                  onTap: () async{

                    if(deliveryPhoto == null){
                      customToast(
                        seconds: 2,
                        context: context,
                        icon: Icons.warning_amber_rounded,
                        width: MediaQuery.of(context).size.width * 0.6,
                        color: AppColors.warningColor,
                        text: 'Debe tomar una Foto de evidencia.',
                        radius: 20,
                      );
                      return;
                    }
                    
                    if(deliveryObservation!.text.trim().isEmpty){
                      customToast(
                        seconds: 2,
                        context: context,
                        icon: Icons.warning_amber_rounded,
                        width: MediaQuery.of(context).size.width * 0.6,
                        color: AppColors.warningColor,
                        text: 'Ingrese una Observación.',
                        radius: 20,
                      );
                      return;
                    }

                    var deliveryStatus = "";
                    if(selectOption == 0){
                      deliveryStatus = "delivered";
                    }else{
                      deliveryStatus = "noDelivered";
                    }

                    await deliveryProvider.read.updateFirebaseDelivery(widget.delivery, deliveryStatus, deliveryObservation!.text.trim(), deliveryPhoto);

                    var deliveryCount;

                    if(deliveryProvider.read.getSelectedDeliveryList == null){
                      deliveryCount = 0;
                    }else{
                      deliveryCount = deliveryProvider.read.getSelectedDeliveryList!.length;
                    }

                    if(deliveryCount > 0){
                      context.goNamed(MultipleDeliveryScreen.name, extra: false);
                    }else{
                      context.go('/');
                    }

                  },
                ),

              ),
            )
            : null,

          ),
        );
      }
    );

  }

}
