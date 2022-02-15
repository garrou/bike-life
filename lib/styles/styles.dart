import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color grey = Color.fromRGBO(91, 97, 90, 1.0);

const Color intermediateGreen = Color.fromRGBO(69, 141, 103, 1.0);
const Color primaryColor =
    Color.fromRGBO(3, 102, 102, 1.0); // Color.fromRGBO(0, 150, 199, 1.0);

const Color green = Color.fromRGBO(85, 187, 57, 1.0);
const Color orange = Color.fromRGBO(255, 153, 0, 1.0);
const Color red = Color.fromRGBO(244, 66, 53, 1.0);

TextStyle linkStyle = const TextStyle(
    decoration: TextDecoration.underline,
    color: Colors.blue,
    fontSize: secondSize);

TextStyle mainTextStyle = GoogleFonts.roboto(fontSize: mainSize);
TextStyle secondTextStyle = GoogleFonts.roboto(fontSize: secondSize);
TextStyle thirdTextStyle = GoogleFonts.roboto(fontSize: intermediateSize);
TextStyle fourthTextStyle = GoogleFonts.roboto(fontSize: 14.0);

TextStyle boldSubTitleStyle =
    GoogleFonts.roboto(fontSize: secondSize, fontWeight: FontWeight.bold);
TextStyle italicTextStyle =
    GoogleFonts.roboto(fontSize: 20.0, fontStyle: FontStyle.italic);

ButtonStyle roundedButtonStyle(Color colorToSet) => ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(thirdSize),
            side: BorderSide(color: colorToSet))),
    backgroundColor: MaterialStateProperty.all(colorToSet));

OutlineInputBorder textFieldBorder(double radius, Color borderColor) =>
    OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: borderColor));
