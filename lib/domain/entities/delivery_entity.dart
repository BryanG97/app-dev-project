
class DeliveryEntity {
  final String id;
  final String address;
  final String customerName;
  final DateTime deliveryDate;
  final String latitude;
  final String longitude;
  final String status;
  final String phoneNumber;
  double ?markerHue;

   List<ProductListEntity>? productList;
  
  DeliveryEntity({
    required this.id,
    required this.address,
    required this.customerName, 
    required this.deliveryDate, 
    required this.latitude, 
    required this.longitude,
    required this.status,
    required this.phoneNumber,
    this.markerHue,
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