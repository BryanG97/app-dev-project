import 'package:app_dev_project/presentation/providers/delivery_provider.dart';
import 'package:flutter/material.dart';


class DeliveryListScreen extends StatelessWidget {
  static const name = 'delivery-list-screen';

  const DeliveryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DeliveryList(),
    );
  }
}

class DeliveryList extends StatefulWidget {
  const DeliveryList({super.key,});

  @override
  State<DeliveryList> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    deliveryProvider.read.getFirebaseDeliveries();

    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 184, 194, 194),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => deliveryProvider.read.getFirebaseDeliveries(),
          ),

          child: const Padding(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),

            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Entregas",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )
                  ],
                ),

                SizedBox(height: 15),

                /* Expanded(
                  child: Consumer(

                  ),
                ), */
                
              ],
            ),
          ),

        ),
      ),
    );

  }

}

