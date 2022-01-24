import 'package:bike_life/routes/add_component_route.dart';
import 'package:bike_life/routes/member_home_route.dart';
import 'package:bike_life/routes/tip_details_route.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/routes/bike_details_route.dart';
import 'package:bike_life/routes/component_details_route.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:bike_life/views/home/intro.dart';
import 'package:bike_life/views/member/add_bike.dart';
import 'package:bike_life/views/member/profile.dart';
import 'package:bike_life/views/member/tips.dart';
import 'package:bike_life/styles/general.dart';
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
              primaryColor: deepGreen,
              brightness: Brightness.light),
          initialRoute: '/intro',
          routes: {
            '/intro': (context) => const IntroPage(),
            '/': (context) => const HomePage(),
            '/login': (context) => const SigninPage(),
            '/signup': (context) => const SignupPage(),
            MemberHomeRoute.routeName: (context) => const MemberHomeRoute(),
            '/add-bike': (context) => const AddBikePage(),
            '/profile': (context) => const ProfilePage(),
            '/tips': (context) => const TipsPage(),
            ComponentDetailsRoute.routeName: (context) =>
                const ComponentDetailsRoute(),
            BikeDetailsRoute.routeName: (context) => const BikeDetailsRoute(),
            AddComponentRoute.routeName: (context) => const AddComponentRoute(),
            TipDetailsRoute.routeName: (context) => const TipDetailsRoute()
          });
}
