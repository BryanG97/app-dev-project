
class DeliveryEntity {
  final String documentId;
  final String deliveryId;
  final String address;
  final String customerName;
  final DateTime deliveryDate;
  final String latitude;
  final String longitude;
  final String status;
  final String phoneNumber;
  double ?markerHue;
  final String ?deliveryObservation;

   List<ProductListEntity>? productList;
  
  DeliveryEntity({
    required this.documentId,
    required this.deliveryId,
    required this.address,
    required this.customerName, 
    required this.deliveryDate, 
    required this.latitude, 
    required this.longitude,
    required this.status,
    required this.phoneNumber,
    this.markerHue,
    this.deliveryObservation,
    this.productList,
  });

}

class ProductListEntity {
  String productName;
  String quantity;

  ProductListEntity({
    required this.productName, 
    required this.quantity, 
  });

}