import 'package:flutter/material.dart';

class DeliveryGifLoadingDialog extends StatelessWidget {
  const DeliveryGifLoadingDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Image.asset("assets/images/delivered.gif"),
      ),
    );
  }
}
