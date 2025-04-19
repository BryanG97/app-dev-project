import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryController extends SimpleNotifier {
  List<DeliveryEntity> _deliveryList = [];

  List<DeliveryEntity> _selectedDeliveriesList = [];

  //GETTERS
  List<DeliveryEntity>? get getDeliveryList => _deliveryList;

  List<DeliveryEntity>? get getSelectedDeliveryList => _selectedDeliveriesList;


  //SETTERS
  set setDeliveryToList(DeliveryEntity delivery){
    _deliveryList.add(delivery);
  }

  // Method to get firebase collection deliveries
  Future<void> getFirebaseDeliveries() async {
    _deliveryList = [];

    try{

      final itemsRef = FirebaseFirestore.instance.collection('ORD123456');
      final snapshot = await itemsRef.get();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        final delivery = DeliveryEntity(
          id: data['id'],
          address: data['address'],
          customerName: data['customerName']??"",
          deliveryDate: (data['deliveryDate'] as Timestamp).toDate(),
          latitude: data['latitude'],
          longitude: data['longitude'],
          status: data['status'],
          // Agrega aquí todos los campos que tenga tu `DeliveryEntity`
        );

        _deliveryList.add(delivery);

      }
      notify(); // Muy importante: notifica a los listeners

    }catch(e){
      _deliveryList = [];
    }
  }

  //Method to save selected
  selectDelivery(DeliveryEntity delivery){
    _selectedDeliveriesList.add(delivery);
  }
  
  //Method to delete selected
  unselectDelivery(DeliveryEntity delivery){
    _selectedDeliveriesList.removeWhere((d) => d.id == delivery.id);
  }
  
  //Method to deleted selected
  deleteSelectedDeliveries(){
    _selectedDeliveriesList = [];
  }

}