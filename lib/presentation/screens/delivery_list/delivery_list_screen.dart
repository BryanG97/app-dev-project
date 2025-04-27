import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:app_dev_project/presentation/providers/delivery_provider.dart';
import 'package:app_dev_project/presentation/screens/delivery_detail/delivery_detail_screen.dart';
import 'package:app_dev_project/presentation/screens/multiple_delivery/multiple_delivery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
  late Future<void> _deliveriesFuture;

  bool multipleSelection = false;

  @override
  void initState() {
    super.initState();
    _deliveriesFuture = deliveryProvider.read.getFirebaseDeliveries();
  }

  @override
  Widget build(BuildContext context)  {

    return FutureBuilder(
      future: _deliveriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          //backgroundColor: const Color.fromARGB(255, 184, 194, 194),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await deliveryProvider.read.getFirebaseDeliveries();
                setState(() {
                  _deliveriesFuture = Future.value(); // Para evitar recarga innecesaria
                });
              },

              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),

                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Entregas",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(width: 200),

                        multipleSelection ? 
                        Consumer(
                          builder: (context, ref, child) {
                            final data = ref.watch(deliveryProvider);
                            final selectedCount = data.getSelectedDeliveryList?.length ?? 0;
                          
                            return GestureDetector(
                              onTap: (){
                                if(selectedCount > 0){
                                  context.goNamed(MultipleDeliveryScreen.name, extra: false);
                                }
                              },
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  //const Icon(Icons.delivery_dining, size: 28),
                                  Image.asset("assets/images/delivery_image.png", height: 40, width: 40),
                                  if (selectedCount > 0)
                                  
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$selectedCount',
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }
                        ): const SizedBox(height: 40),


                      ],
                    ),

                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Entrega múltiple', style: TextStyle(fontSize: 16)),
                          Switch(
                            value: multipleSelection,
                            onChanged: (bool value) {
                              setState(() {
                                multipleSelection = value;
                                if(!value) deliveryProvider.read.deleteMultipleSelectedDeliveries();
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child){
                          final data = ref.watch(deliveryProvider);
                          final deliveryList = data.getDeliveryList;

                          if (deliveryList != null && deliveryList.isNotEmpty) {

                            return ListView.builder(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: deliveryList.length,
                              itemBuilder: (context, index){
                                final delivery = deliveryList[index];
                                //deliveryProvider.read.deleteSelectedDeliveries();

                                return InkWell(
                                  onTap: (){
                                    if (!multipleSelection) {
                                        deliveryProvider.read.deleteSimpleSelectedDeliveries();
                                        deliveryProvider.read.selectSimpleDelivery(delivery);

                                      if(delivery.status == "pending"){
                                        context.goNamed(MultipleDeliveryScreen.name, extra: false);
                                      }else{
                                        context.goNamed(DeliveryDetailScreen.name, extra: delivery);
                                      }

                                    }
                                  },

                                  child: DeliveryCard(
                                    deliveryEntity: delivery,
                                    index: index + 1,
                                    multipleSelection: multipleSelection,
                                  ),

                                );

                              },
                            );

                          }else if (deliveryList != null && deliveryList.isEmpty) {
                            return const Center(
                              child: Text('No hay entregas.'),
                            );
                          }else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                        }
                      ),
                    ),
                    
                  ],
                ),
              ),

            ),
          ),
        );

        
      },
    );

  }

}

class DeliveryCard extends StatelessWidget {
  final DeliveryEntity deliveryEntity;
  final int index;
  final bool multipleSelection;

  const DeliveryCard({
    super.key,
    required this.deliveryEntity,
    required this.index,
    required this.multipleSelection,
  });

  @override
  Widget build(BuildContext context) {
    final selectedList = deliveryProvider.read.getSelectedDeliveryList;
    final isChecked = selectedList?.any((e) => e.deliveryId == deliveryEntity.deliveryId) ?? false;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            
            leading: SizedBox(
              height: 200,
              child: Column(
                children: [
                  Flexible(
                    child: Image.asset("assets/images/delivery_image.png", height: 100, width: 100),
                  ),
                ],
              ),
            ),

            title: Text(
              deliveryEntity.customerName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  deliveryEntity.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),

                Text(
                  DateFormat('dd-MM-yyyy HH:mm').format(deliveryEntity.deliveryDate),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),

                //deliveryEntity.status == "pending"?
                if(deliveryEntity.status == "pending")
                  const Text(
                    'PENDIENTE',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                
                
                if(deliveryEntity.status == "delivered")
                  const Text(
                    'ENTREGADO',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                
                
                if(deliveryEntity.status == "noDelivered")
                  const Text(
                    'NO ENTREGADO',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),              
              
              ],
            ),

            trailing:  multipleSelection && deliveryEntity.status == "pending"
              ? DeliveryCheckWidget(
                  delivery: deliveryEntity,
                  isChecked: isChecked,
                )
              : null,

          ),

        ),
      ),

    );

  }
}

//CHECK BOX COMPONENT
class DeliveryCheckWidget extends StatefulWidget {
  final DeliveryEntity delivery;
  final bool isChecked;

  const DeliveryCheckWidget({
    super.key,
    required this.delivery,
    required this.isChecked
  });

  @override
  State<DeliveryCheckWidget> createState() => _DeliveryCheckWidgetState();
}

class _DeliveryCheckWidgetState extends State<DeliveryCheckWidget> {
  bool isSelected = false;

  @override
  void initState(){
    super.initState();
    isSelected = widget.isChecked;
  }

  void _onChanged(bool? value) {
    setState(() {
      isSelected = value ?? false;
    });

    if (isSelected) {
      deliveryProvider.read.selectMultipleDelivery(widget.delivery);
    } else {
      deliveryProvider.read.unselectMultipleDelivery(widget.delivery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isSelected,
      onChanged: _onChanged,
    );
  }
}

