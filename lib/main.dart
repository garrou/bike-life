import 'package:bike_life/providers/theme_provider.dart';
import 'package:bike_life/providers/year_provider.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

// TODO: Fix bug date when update components
// TODO; inactive when change email
// TODO: suggest components with user components
// TODO: check if icon are all empty or full
// TODO: check brand length server side and front
// TODO: check token
// TODO: add message before change component to update brand and price

void main() {
  setPathUrlStrategy();
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
