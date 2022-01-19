import 'package:flutter/foundation.dart';

String endpoint =
    [TargetPlatform.android, TargetPlatform.iOS].contains(defaultTargetPlatform)
        ? "http://10.0.2.2:8100"
        : "http://localhost:8100";

const String title = "Bike's life";
const String quote = "La santé de votre vélo se surveille de près.";

const double ratio = 200.0;

const double buttonWidth = 180.0;
const double buttonHeight = 40.0;

const double imageSize = 500.0;

const double maxPadding = 150.0;
const double maxSize = 600.0;

const double mainSize = 30.0;
const double secondSize = 20.0;
const double intermediateSize = 18.0;
const double thirdSize = 10.0;

const int minPasswordSize = 8;

const int httpCodeOk = 200;
const int httpCodeCreated = 201;