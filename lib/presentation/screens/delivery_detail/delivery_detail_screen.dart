import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:app_dev_project/presentation/widgets/custom_button.dart';
import 'package:app_dev_project/presentation/widgets/icon_action_whatsapp_widget.dart';
import 'package:app_dev_project/presentation/widgets/icon_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeliveryDetailScreen extends StatefulWidget {
  static const name = 'delivery-detail-screen';

  final DeliveryEntity delivery;

  const DeliveryDetailScreen({
    super.key,
    required this.delivery,
    });

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailState();
}

class _DeliveryDetailState extends State<DeliveryDetailScreen> {
  
  List<String> phoneNumbers = [];
  

  @override
  Widget build(BuildContext context) {

    phoneNumbers = widget.delivery.phoneNumber.split(";");

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
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Text(
                      "Orden N° ${widget.delivery.id}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Container()),
              Image.asset("assets/images/delivery_image.png", height: 40, width: 40),
                  ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Text(
                        widget.delivery.customerName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /* IconActionMap(
                      iconData: Icons.location_on,
                      active: true,
                      longitude: this.widget.contentEntity.longitudEntrega!,
                      latitude: this.widget.contentEntity.latitudEntrega!,
                    ),
                    const SizedBox(width: 10),*/
                    ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: phoneNumbers.length,
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          if (phoneNumbers[index].isNotEmpty) {
                            return Row(
                              children: [
                                IconAction(
                                  iconData: Icons.call,
                                  active: true,
                                  phoneNumber: phoneNumbers[index],
                                  index: (index + 1).toString(),
                                ),
                                const SizedBox(width: 10),
                                IconActionWhatsapp(
                                  iconData: FontAwesomeIcons.whatsapp,
                                  active: true,
                                  phoneNumber: phoneNumbers[index],
                                  index: (index + 1).toString(),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Subtitle(
                string: "Dirección",
                iconData: Icons.location_on,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Text(
                        widget.delivery.address,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1.5,
              ),

              const SizedBox(height: 20),

              const Subtitle(
                string: "Artículos",
                iconData: Icons.list,
              ),

              const SizedBox(height: 10),

              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: widget.delivery.productList!.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final product = widget.delivery.productList![index];

                      return InkWell(
                        /* onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DetailsChecklistPage(
                                activeButtons: this.widget.isActivedButton!,
                                index: index,
                                indexArticle: index,
                                indexContent: this.widget.indexContent!,
                                contentEntity: this.widget.contentEntity,
                                secuencialTransporteMercaderiaDetalle: article.secuencialTransporteMercaderiaDetalle!,
                                secuencialConvenioDetalle: article.secuencialConvenioDetalle!,
                              );
                            },
                          ),
                        ), */
                        child: ProductCard(
                          productEntity: product,
                          index: index + 1,
                        ),
                      );
                    },
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
            child: 

                CustomButton(
                  label: "Continuar",
                  fontSizeText: 17,
                  color: Theme.of(context).colorScheme.primary,
                  onTap: () async{
                    
                  },
                ),

          ),
        ),
        
      )
    );

  }

}

class Subtitle extends StatelessWidget {
  final String string;
  final IconData iconData;
  const Subtitle({
    super.key,
    required this.string,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(width: 16),
          Text(
            string,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  final ProductListEntity productEntity;
  final int index;

  const ProductCard({
    super.key,
    required this.productEntity,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
        child: Row(
          children: [
            // Línea vertical a la izquierda
            Container(
              width: 22, // grosor de la franja
              height: 71, // ajusta si necesitas más alto
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Text(
                  index.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productEntity.productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Cantidad: ${productEntity.quantity}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
