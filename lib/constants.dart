import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String webEndpoint = "http://localhost:8080/api/v1";
const String androidEndpoint = "http://10.0.2.2:8080/api/v1";

const String title = "Bike's life";
const String quote = "La santé de votre vélo se surveille de près.";
const String homeImg = "assets/bike.png";

const double buttonWidth = 200.0;
const double buttonHeight = 50;

const double imageSize = 500.0;

const double paddingTop = 30.0;
const double maxPadding = 100.0;
const double maxSize = 600.0;

const double mainSize = 30.0;
const double secondSize = 20.0;
const double thirdSize = 10.0;

const Color mainColor = Color.fromARGB(255, 53, 143, 128);
const Color secondColor = Color.fromARGB(255, 3, 102, 102);

TextStyle mainTextStyle = GoogleFonts.roboto(fontSize: mainSize);
TextStyle secondTextStyle = GoogleFonts.roboto(fontSize: secondSize);
TextStyle thirdTextStyle = GoogleFonts.roboto(fontSize: thirdSize);
TextStyle italicTextStyle =
    GoogleFonts.roboto(fontSize: secondSize, fontStyle: FontStyle.italic);
TextStyle linkTextStyle = GoogleFonts.roboto(fontSize: secondSize);
