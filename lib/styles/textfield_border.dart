import 'package:flutter/material.dart';

OutlineInputBorder textFieldBorder(double radius, Color borderColor) =>
    OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: borderColor));
