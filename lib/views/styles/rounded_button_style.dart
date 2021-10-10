import 'package:bike_life/constants.dart';
import 'package:flutter/material.dart';

ButtonStyle roundedButtonStyle(Color colorToSet) {
  return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(thirdSize),
              side: BorderSide(color: colorToSet))),
      backgroundColor: MaterialStateProperty.all(colorToSet));
}
