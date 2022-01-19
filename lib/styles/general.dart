import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color mainColor = Color.fromARGB(255, 53, 143, 128);
const Color secondColor = Color.fromARGB(255, 3, 102, 102);
const Color errorColor = Color.fromARGB(255, 255, 0, 0);

TextStyle linkStyle = const TextStyle(
    decoration: TextDecoration.underline,
    color: Colors.blue,
    fontSize: secondSize);

TextStyle mainTextStyle = GoogleFonts.roboto(fontSize: mainSize);
TextStyle secondTextStyle = GoogleFonts.roboto(fontSize: secondSize);
TextStyle thirdTextStyle = GoogleFonts.roboto(fontSize: intermediateSize);

TextStyle whiteThirdTextStyle =
    GoogleFonts.roboto(fontSize: 15.0, color: Colors.white);
TextStyle boldSubTitleStyle =
    GoogleFonts.roboto(fontSize: secondSize, fontWeight: FontWeight.bold);
TextStyle italicTextStyle =
    GoogleFonts.roboto(fontSize: 20.0, fontStyle: FontStyle.italic);