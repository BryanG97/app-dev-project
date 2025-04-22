import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IconAction extends StatelessWidget {
  final IconData iconData;
  final double? size, iconSize;
  final bool active;
  final String phoneNumber, index;
  const IconAction({
    super.key,
    required this.iconData,
    this.size = 50,
    this.iconSize = 22,
    this.active = false,
    required this.phoneNumber,
    required this.index,
  });
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await _makePhoneCall(phoneNumber);
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
            Text(
              index,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
