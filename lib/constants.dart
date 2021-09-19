import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String title = "Bike's life";
const String quote = "La santé de votre vélo se surveille de près.";

const String devServer = "http://localhost:8080";

const double maxPadding = 100.0;
const double maxSize = 600.0;

const double mainSize = 30.0;
const double secondSize = 20.0;
const double thirdSize = 10.0;

const Color mainColor = Color.fromARGB(255, 53, 143, 128);
const Color secondColor = Color.fromARGB(255, 3, 102, 102);

TextStyle mainTextStyle = GoogleFonts.baloo(fontSize: mainSize);
TextStyle secondTextStyle = GoogleFonts.baloo(fontSize: secondSize);
TextStyle thirdTextStyle = GoogleFonts.baloo(fontSize: thirdSize);
TextStyle italicTextStyle =
    GoogleFonts.baloo(fontSize: secondSize, fontStyle: FontStyle.italic);
