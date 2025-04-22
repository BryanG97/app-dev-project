import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
    this.fontSizeText = 12,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;
  final double? fontSizeText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).colorScheme.primary,
        minimumSize: const Size(88, 36),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      onPressed: onTap,
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white,),
                const SizedBox(width: 10),
                Text(label, style: TextStyle(color:Colors.white)),
              ],
            )
          : Text(
              label,
              style: TextStyle(fontSize: this.fontSizeText, color: Color.fromRGBO(255, 255, 255, 1)),
            ),
    );
  }
}
