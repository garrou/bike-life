import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';

ButtonStyle roundedButtonStyle(Color colorToSet) => ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(thirdSize),
            side: BorderSide(color: colorToSet))),
    backgroundColor: MaterialStateProperty.all(colorToSet));
