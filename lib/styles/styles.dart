import 'package:bike_life/providers/theme_provider.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

const Color primaryColor = Color.fromARGB(255, 64, 145, 108);
const Color intermediateColor = Color.fromRGBO(69, 141, 103, 1.0);
const Color green = Color.fromRGBO(85, 187, 57, 1.0);
const Color orange = Color.fromRGBO(255, 153, 0, 1.0);
const Color red = Color.fromRGBO(244, 66, 53, 1.0);
const Color grey = Color.fromRGBO(91, 97, 90, 1.0);

TextStyle linkStyle = const TextStyle(
    decoration: TextDecoration.underline,
    color: Colors.blue,
    fontSize: secondSize);

TextStyle setStyle(BuildContext context, double size) =>
    GoogleFonts.roboto(fontSize: size, color: colorByTheme(context));

TextStyle setBoldStyle(BuildContext context, double size) => GoogleFonts.roboto(
    fontSize: size, color: colorByTheme(context), fontWeight: FontWeight.bold);

charts.Color chartColorByTheme(BuildContext context) =>
    context.read<ThemeModel>().isDark
        ? charts.MaterialPalette.white
        : charts.MaterialPalette.black;

Color colorByTheme(BuildContext context) =>
    context.watch<ThemeModel>().isDark ? Colors.white : Colors.black;

Color colorFollowTheme(BuildContext context) =>
    context.watch<ThemeModel>().isDark
        ? const Color.fromARGB(255, 48, 48, 48)
        : Colors.white;

TextStyle mainTextStyle = GoogleFonts.roboto(fontSize: firstSize);
TextStyle secondTextStyle = GoogleFonts.roboto(fontSize: secondSize);
TextStyle thirdTextStyle = GoogleFonts.roboto(fontSize: intermediateSize);
TextStyle boldTextStyle =
    GoogleFonts.roboto(fontSize: secondSize, fontWeight: FontWeight.bold);
TextStyle italicTextStyle =
    GoogleFonts.roboto(fontSize: secondSize, fontStyle: FontStyle.italic);

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
