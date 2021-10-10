import 'package:bike_life/constants.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/material.dart';

ButtonStyle roundedButtonStyle(Color colorToSet) {
  return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(mainSize),
              side: BorderSide(color: colorToSet))),
      backgroundColor: MaterialStateProperty.all(colorToSet));
}
