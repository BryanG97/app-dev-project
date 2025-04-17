
class DeliveryEntity {
  final String address;
  final String customerName;
  final DateTime deliveryDate;
  final String latitude;
  final String longitude;
  
  DeliveryEntity({
    required this.address,
    required this.customerName, 
    required this.deliveryDate, 
    required this.latitude, 
    required this.longitude, 
  });

}