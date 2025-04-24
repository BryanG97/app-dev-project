import 'package:app_dev_project/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customToast({
  required BuildContext context,
  required double width,
  required String text,
  required Color color,
  required int seconds,
  IconData? icon,
  double? radius,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  final scaffoldMessenger = ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
      behavior: SnackBarBehavior.floating,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      width: width,
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      content: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (icon != null) ...[
            SizedBox(
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
          SizedBox(
            width: icon == null ? width * .9 : width * .75,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      duration: Duration(seconds: seconds),
    ),
  );
  return scaffoldMessenger;
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> successMessageToast({
  required BuildContext context,
  required String text,
  required int seconds,
  double? width,
}) {
  return customToast(
    context: context,
    width: width ?? MediaQuery.of(context).size.width * .9,
    text: text,
    color: AppColors.successColor,
    seconds: seconds,
    icon: FontAwesomeIcons.check,
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorMessageToast({
  required BuildContext context,
  required String text,
  required int seconds,
  double? width,
}) {
  return customToast(
    context: context,
    width: width ?? MediaQuery.of(context).size.width * .9,
    text: text,
    color: AppColors.errorColor,
    seconds: seconds,
    icon: FontAwesomeIcons.solidCircleXmark,
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> warningMessageToast(
    {required BuildContext context,
    required String text,
    required int seconds,
    double? width}) {
  return customToast(
    context: context,
    width: width ?? MediaQuery.of(context).size.width * .9,
    text: text,
    color: AppColors.warningColor,
    seconds: seconds,
    icon: FontAwesomeIcons.triangleExclamation,
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> infoMessageToast({
  required BuildContext context,
  required String text,
  required int seconds,
  double? width,
}) {
  return customToast(
    context: context,
    width: width ?? MediaQuery.of(context).size.width * .9,
    text: text,
    color: AppColors.infoColor,
    seconds: seconds,
    icon: FontAwesomeIcons.circleInfo,
  );
}
