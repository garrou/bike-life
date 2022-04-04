import 'package:bike_life/providers/theme_provider.dart';
import 'package:bike_life/providers/year_provider.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: Fix bug date when update components
// TODO: store km change
// TODO; inactive when change email
// TODO: suggest components with user components
// TODO: check if icon are all empty or full
// TODO: say at user "think to add price and brand before change compo"
// TODO: check brand length server side and front

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Year(DateTime.now().year))
  ], child: const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            title: "Bike's Life",
            theme: themeNotifier.isDark ? ThemeData.dark() : ThemeData.light(),
            home: const HomePage(),
          );
        }),
      );
}
