import 'dart:io';
import 'dart:typed_data';

import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeliveryController extends SimpleNotifier {

  String idCollection = "ORD123456";
  String idDetaillCollection = "PR01";
  String firebaseStorageRefrence= "deliveries";

   bool _loading = false;

  List<DeliveryEntity> _deliveryList = [];

  List<DeliveryEntity> _selectedDeliveriesList = [];

  String _deliveryImageUrl = "";

  LatLng _currentLocation = const LatLng(0,0);

  //GETTERS
  List<DeliveryEntity>? get getDeliveryList => _deliveryList;

  List<DeliveryEntity>? get getSelectedDeliveryList => _selectedDeliveriesList;

  bool get getLoading => _loading;

  String get getDeliveryImageUrl => _deliveryImageUrl;

  LatLng get getCurrentLocation => _currentLocation;

  //SETTERS
  set setDeliveryToList(DeliveryEntity delivery){
    _deliveryList.add(delivery);
  }

  set setLoading(bool value) {
    _loading = value;
    notify();
  }
  
  set setDeliveryImageUrl(String url) {
    _deliveryImageUrl = url;
  }
  
  set setCurrentLocation(LatLng location) {
    _currentLocation = location;
  }

  // Method to get firebase collection deliveries
  Future<void> getFirebaseDeliveries() async {
    _deliveryList = [];

    try{

      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) return; 

      final itemsRef = FirebaseFirestore.instance
        .collection(idCollection)
        .where('driverId', isEqualTo: user.uid);

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
          deliveryImageUrl: data['deliveryImageUrl'] ?? '',
          productList: products,
          deliveryObservation: data['deliveryObservation']
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
  Future<void> updateFirebaseDelivery(DeliveryEntity delivery, String status ,String ?deliveryObservation, XFile? deliveryPhoto) async {
    setLoading = true;
      try{

        await uploadDeliveryPhoto(deliveryPhoto);

        await FirebaseFirestore.instance
          .collection(idCollection)
          .doc(delivery.documentId)
          .update({
            'deliveryObservation': deliveryObservation,
            'deliveryImageUrl': _deliveryImageUrl,
            'status': status,
        });

        setLoading = false;
        unselectMultipleDelivery(delivery);
      }catch(e){
        setLoading = false;
      }
  }

  //Method to compress file size
  Future<Uint8List> compressList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(list, quality: 40);
    print('Imagen comprimida-----------');
    return result;
  }

  //Method to upload firebase image
  Future<void> uploadDeliveryPhoto(XFile? deliveryPhoto) async {

    _deliveryImageUrl = "";
    
    if (deliveryPhoto == null) {
      print('No hay foto-----------');
      return;
    }

      try {
      // Read image as bytes
      File imageFile = File(deliveryPhoto.path);
      Uint8List imageBytes = await imageFile.readAsBytes();

      //Compress image
      Uint8List compressedBytes = await compressList(imageBytes);

      //Create store reference
      String fileName = path.basename(deliveryPhoto.path);
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child(firebaseStorageRefrence)
          .child(fileName);

      //Upload image bytes
      UploadTask uploadTask = storageRef.putData(
        compressedBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      //Get photo url
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      _deliveryImageUrl = downloadUrl;

      print('URL de la foto subida: $downloadUrl');
    } catch (e) {
      print('Error al subir la foto: $e');
    }
  }

  //Method to get current location
  Future<void> getGpsLocation() async {
    bool isActiveGeolocation;
    LocationPermission permission;

    isActiveGeolocation = await Geolocator.isLocationServiceEnabled();
    if (!isActiveGeolocation) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
        }
    }

    Position currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _currentLocation = LatLng(
      double.parse(currentLocation.latitude.toString()),
      double.parse(currentLocation.longitude.toString()),
    );

  }

}
