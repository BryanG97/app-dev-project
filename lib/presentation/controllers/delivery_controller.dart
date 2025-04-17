import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryController extends SimpleNotifier {
  List<DeliveryEntity> _deliveryList = [];

  //GETTERS
  List<DeliveryEntity>? get getDeliveryList => _deliveryList;

  //SETTERS
  set setDeliveryToList(DeliveryEntity delivery){
    _deliveryList.add(delivery);
  }

  // Method to get firebase collection deliveries
  Future<void> getFirebaseDeliveries() async {
    _deliveryList = [];

    try{

      final itemsRef = FirebaseFirestore.instance
        .collection('ORD123456');

      final snapshot = await itemsRef.get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        print("Datos de firebase: ${data}");
        //print("Producto: ${data['name']}, Cantidad: ${data['quantity']}");
      }

    }catch(e){
      _deliveryList = [];
    }
  }

}