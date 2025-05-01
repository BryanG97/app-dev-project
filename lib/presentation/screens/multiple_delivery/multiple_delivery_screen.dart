import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:app_dev_project/presentation/providers/delivery_provider.dart';
import 'package:app_dev_project/presentation/screens/delivery_detail/delivery_detail_screen.dart';
import 'package:app_dev_project/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class MultipleDeliveryScreen extends StatelessWidget {
  static const name = 'multiple-delivery-screen';
  
  final bool isOnlyView;

  const MultipleDeliveryScreen({
    super.key,
    required this.isOnlyView
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultipleDelivery(
        isOnlyView: isOnlyView,
      ),
    );
  }
}

class MultipleDelivery extends StatefulWidget {
  
  final bool isOnlyView;

  const MultipleDelivery({
    super.key,
    required this.isOnlyView
  });

  @override
  State<MultipleDelivery> createState() => _MultipleDeliveryState();
}

class _MultipleDeliveryState extends State<MultipleDelivery> {

  final ScrollController scrollController = ScrollController();
  GoogleMapController? mapController;

  final Set<Polyline> _polylines = {};

  final List<Marker> _markers = [];
  late BitmapDescriptor _customInitMarker;

  //late final LatLng start = LatLng(-0.257338, -78.530707);
  late final LatLng start;
  late final LatLng end;

  @override
  void initState() {
    super.initState();
    _initializeMapElements();
  }
  
  void _initializeMapElements() async {
    start = deliveryProvider.read.getCurrentLocation;
    await _getEndPoint();
    await _loadCustomIcons();

    if(!widget.isOnlyView){
      _setPolyline(); // Se llama después de cargar íconos
    }
  }

  

  //Method to customize point icons
  Future<void> _getEndPoint() async {
    var deliveryList = deliveryProvider.read.getSelectedDeliveryList;
    if (deliveryList == null || deliveryList.isEmpty) return;

    double maxDistance = 0;
    var farthestPoint = deliveryList.first;

    for (var point in deliveryList) {
      double distanceInMeters = Geolocator.distanceBetween(
        start.latitude,
        start.longitude,
        double.parse(point.latitude),
        double.parse(point.longitude),
      );

      if (distanceInMeters > maxDistance) {
        maxDistance = distanceInMeters;
        farthestPoint = point;
      }
    }

    end = LatLng(
      double.parse(farthestPoint.latitude),
      double.parse(farthestPoint.longitude),
    );
    
  }

  //Method to customize point icons
  Future<void> _loadCustomIcons() async {
    /* if(!widget.isOnlyView){
      _customInitMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), 
        'assets/images/driver_mark.png',
      );
    } */

    setState(() {
      _markers.clear();
      var deliveryList = deliveryProvider.read.getSelectedDeliveryList;

      final List<double> availableHues = [
        BitmapDescriptor.hueRed,
        BitmapDescriptor.hueBlue,
        BitmapDescriptor.hueCyan,
        BitmapDescriptor.hueAzure,
        BitmapDescriptor.hueGreen,
        BitmapDescriptor.hueMagenta,
        BitmapDescriptor.hueOrange,
        BitmapDescriptor.hueRose,
        BitmapDescriptor.hueViolet,
        BitmapDescriptor.hueYellow,
      ];
      availableHues.shuffle();

      if (deliveryList == null || deliveryList.isEmpty) {
        deliveryList = [];
      }

      //Init point
      /* if(!widget.isOnlyView){
        _markers.add(
          Marker(
            markerId: MarkerId(start.toString()),
            icon: _customInitMarker,
            position: start
          ),
        );
      } */
      
      for(int i = 0; i < deliveryList.length; i++){
        final LatLng position = LatLng(double.parse(deliveryList[i].latitude), double.parse(deliveryList[i].longitude));
        deliveryList[i].markerHue = availableHues[i % availableHues.length]; 
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(position.toString()),
              icon: BitmapDescriptor.defaultMarkerWithHue(deliveryList?[i].markerHue??0.0),
              position: position
            ),
          );
        });
      }

    });
  }

  void _setPolyline() async{
    final PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

    const String googleAPIKey = 'AIzaSyBuh38UKClQrLoqhTsazqdcw_rYppZVDxs';

    var deliveryList = deliveryProvider.read.getSelectedDeliveryList ?? [];

    List<PolylineWayPoint> waypoints = deliveryList.map((delivery) {
      return PolylineWayPoint(
        location: "${delivery.latitude},${delivery.longitude}",
        stopOver: true,
      );
    }).toList();

    final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude),
      travelMode: TravelMode.driving,
      wayPoints: waypoints,
      optimizeWaypoints: true,
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
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),

          child: Column(
              children: [

                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if(widget.isOnlyView){
                          final selectedDelivery = deliveryProvider.read.getSelectedDeliveryList;
                          context.goNamed(DeliveryDetailScreen.name, extra:selectedDelivery![0]);
                        }else{
                          context.goNamed(CustomBottomNavigationBar.name);
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const Text(
                      'REGRESAR',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Container()),
                    Image.asset("assets/images/delivery_image.png", height: 40, width: 40),
                  ],
                ),

                SizedBox(
                  //height: 410,
                  child: Text(
                    widget.isOnlyView? "Ubicación de entrega": "Ruta de entregas",
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: widget.isOnlyView? 600 : 410,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: start,
                      zoom: 12,
                    ),
                    markers: Set.from(_markers),
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

                widget.isOnlyView
                  ? const SizedBox()
                  : Expanded(
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
                                  context.goNamed(DeliveryDetailScreen.name, extra: delivery);
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
    final color = HSVColor.fromAHSV(1, deliveryEntity.markerHue??0.0, 1, 1).toColor();

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
        child: Row(
          children: [
            
            Container(
              width: 12,
              height: 71,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deliveryEntity.customerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${deliveryEntity.address}  | ${DateFormat('dd-MM-yyyy HH:mm').format(deliveryEntity.deliveryDate)}",
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