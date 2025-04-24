import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryController extends SimpleNotifier {

  String idCollection = "ORD123456";
  String idDetaillCollection = "PR01";

   bool _loading = false;

  List<DeliveryEntity> _deliveryList = [];

  List<DeliveryEntity> _selectedDeliveriesList = [];

  //GETTERS
  List<DeliveryEntity>? get getDeliveryList => _deliveryList;

  List<DeliveryEntity>? get getSelectedDeliveryList => _selectedDeliveriesList;

  bool get getLoading => _loading;


  //SETTERS
  set setDeliveryToList(DeliveryEntity delivery){
    _deliveryList.add(delivery);
  }

  set setLoading(bool value) {
    _loading = value;
    notify();
  }

  // Method to get firebase collection deliveries
  Future<void> getFirebaseDeliveries() async {
    _deliveryList = [];

    try{

      final itemsRef = FirebaseFirestore.instance.collection(idCollection);
      final snapshot = await itemsRef.get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        
        //To read delivery products
        final productSnapshot = await doc.reference.collection(idDetaillCollection).get();

        final products = productSnapshot.docs.map((productDoc) {
          final productData = productDoc.data();
          return ProductListEntity(
            productName: productData['productName'],
            quantity: productData['quantity'],
          );
        }).toList();

        final delivery = DeliveryEntity(
          documentId: doc.id,
          deliveryId: data['deliveryId'],
          address: data['address'],
          customerName: data['customerName']??"",
          deliveryDate: (data['deliveryDate'] as Timestamp).toDate(),
          latitude: data['latitude'],
          longitude: data['longitude'],
          status: data['status'],
          phoneNumber: data['phoneNumber'],
          productList: products
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
  selectMultipleDelivery(DeliveryEntity delivery){
    _selectedDeliveriesList.add(delivery);
    notify();
  }
  
  //Method to delete selected
  unselectMultipleDelivery(DeliveryEntity delivery){
    _selectedDeliveriesList.removeWhere((d) => d.deliveryId == delivery.deliveryId);
    notify();
  }
  
  //Method to deleted selected
  deleteMultipleSelectedDeliveries(){
    _selectedDeliveriesList = [];
    notify();
  }

  //Method to save selected
  selectSimpleDelivery(DeliveryEntity delivery){
    _selectedDeliveriesList.add(delivery);
  }

  //Method to deleted selected
  deleteSimpleSelectedDeliveries(){
    _selectedDeliveriesList = [];
  }

  // Method to update firebase register
  Future<void> updateFirebaseDelivery(DeliveryEntity delivery, String status ,String ?deliveryObservation) async {
    setLoading = true;
      try{

        await FirebaseFirestore.instance
          .collection(idCollection)
          .doc(delivery.documentId)
          .update({
            'deliveryObservation': deliveryObservation,
            'status': status,
        });

        setLoading = false;

      }catch(e){
        setLoading = false;
      }
    }
  }
