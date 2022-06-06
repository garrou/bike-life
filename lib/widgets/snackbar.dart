import 'package:bike_life/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

const double iconSize = 40;
const int iconRotation = 0;

void showErrorSnackBar(BuildContext context, String message) {
  showTopSnackBar(
      context,
      CustomSnackBar.error(
        iconRotationAngle: iconRotation,
        message: message,
        icon: const Icon(Icons.error_outlined,
            color: Colors.white, size: iconSize),
      ));
}

void showSuccessSnackBar(BuildContext context, String message) {
  showTopSnackBar(
      context,
      CustomSnackBar.success(
        iconRotationAngle: iconRotation,
        message: message,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.error_outlined,
            color: Colors.white, size: iconSize),
      ));
}
