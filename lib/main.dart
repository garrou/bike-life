import 'package:bike_life/constants.dart';
import 'package:bike_life/routes/bike_details_route.dart';
import 'package:bike_life/routes/component_details_route.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:bike_life/views/member/add_bike.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/views/member/profile.dart';
import 'package:bike_life/views/member/tips.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) => MaterialApp(
          title: title,
          theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: mainColor,
              brightness: Brightness.light),
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/login': (context) => const SigninPage(),
            '/signup': (context) => const SignupPage(),
            '/home': (context) => const MemberHomePage(),
            '/add-bike': (context) => const AddBikePage(),
            '/profile': (context) => const ProfilePage(),
            '/tips': (context) => const TipsPage(),
            ComponentDetailsRoute.routeName: (context) =>
                const ComponentDetailsRoute(),
            BikeDetailsRoute.routeName: (context) => const BikeDetailsRoute()
          });
}
