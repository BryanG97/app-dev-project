import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:app_dev_project/presentation/providers/delivery_provider.dart';
import 'package:app_dev_project/presentation/screens/delivery_detail/delivery_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MultipleDeliveryScreen extends StatelessWidget {
  static const name = 'multiple-delivery-screen';

  const MultipleDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MultipleDelivery(),
    );
  }
}

class MultipleDelivery extends StatefulWidget {
  
  const MultipleDelivery({super.key,});

  @override
  State<MultipleDelivery> createState() => _MultipleDeliveryState();
}

class _MultipleDeliveryState extends State<MultipleDelivery> {

  final ScrollController scrollController = ScrollController();
  GoogleMapController? mapController;

  final Set<Polyline> _polylines = {};

  final LatLng start = LatLng(-0.257338, -78.530707);
  final LatLng end = LatLng(-0.230000, -78.520000);

  @override
  void initState() {
    super.initState();
    _setPolyline();
  }

  void _setPolyline() async{
    final PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

    const String googleAPIKey = 'AIzaSyBuh38UKClQrLoqhTsazqdcw_rYppZVDxs';

    final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        _polylines.add(Polyline(
          polylineId: const PolylineId("ruta-real"),
          color: const Color.fromARGB(255, 33, 103, 243),
          width: 5,
          points: polylineCoordinates,
        ));
      });
    } else {
      print('Error obteniendo la ruta: ${result.errorMessage}');
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 184, 194, 194),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),

          child: Column(
              children: [

                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const Text(
                      'REGRESAR',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                SizedBox(
                  height: 380,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: start, // Latitud/longitud de ejemplo (Lima)
                      zoom: 11.5,
                    ),
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    polylines: _polylines,
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                  ),
                ),

                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1.5,
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: Consumer(
                    builder: (context, ref, child){
                      final data = ref.watch(deliveryProvider);
                      final deliveryList = data.getSelectedDeliveryList;

                      if (deliveryList == null || deliveryList.isEmpty) {
                        return const Center(child: Text("No hay entregas seleccionadas"));
                      }

                      return ListView.builder(
                        controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: deliveryList.length,
                          itemBuilder: (context, index){
                            final delivery = deliveryList[index];

                            return InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const DeliveryDetailScreen();
                                    },
                                  ),
                                );
                              },

                              child: DeliveryCard(
                                deliveryEntity: delivery,
                                index: index + 1,
                              ),

                            );

                          }
                      );

                    }
                  ),
                ),

              ],
          ),   

        ),

      ),
    );

  }

}

class DeliveryCard extends StatelessWidget {
  final DeliveryEntity deliveryEntity;
  final int index;

  const DeliveryCard({
    super.key,
    required this.deliveryEntity,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {

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

              ],
            ),

          ),

        ),
      ),

    );

  }
}