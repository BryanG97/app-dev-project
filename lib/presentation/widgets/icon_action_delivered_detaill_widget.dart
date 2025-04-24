import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:app_dev_project/presentation/screens/delivery_product/delivery_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class IconActionDeliveredDetail extends StatelessWidget {
  final IconData iconData;
  final double? size, iconSize;
  final bool active;
  final DeliveryEntity delivery;

  const IconActionDeliveredDetail({
    super.key,
    required this.iconData,
    this.size = 50,
    this.iconSize = 22,
    this.active = false,
    required this.delivery,
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.goNamed(DeliveryProductScreen.name, extra: delivery);
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: active ? Theme.of(context).colorScheme.primary : Color.fromRGBO(95, 92, 92, 1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: iconSize,
            ),
          ],
        ),
      ),
    );
  }
}
