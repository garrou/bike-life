import 'package:bike_life/styles/theme_model.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return MaterialApp(
            title: "Bike's Life",
            theme: themeNotifier.isDark ? ThemeData.dark() : ThemeData.light(),
            home: const HomePage());
      }));
}
