import 'package:bike_life/constants.dart';
import 'package:bike_life/routes/add_bike_route.dart';
import 'package:bike_life/routes/bike_details_route.dart';
import 'package:bike_life/routes/component_details_route.dart';
import 'package:bike_life/routes/member_home_route.dart';
import 'package:bike_life/routes/profile_page_route.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:bike_life/views/member/tips.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          MemberHomeRoute.routeName: (context) => const MemberHomeRoute(),
          AddBikeRoute.routeName: (context) => const AddBikeRoute(),
          ProfilePageRoute.routeName: (context) => const ProfilePageRoute(),
          '/tips': (context) => const TipsPage(),
          ComponentDetailsRoute.routeName: (context) =>
              const ComponentDetailsRoute(),
          BikeDetailsRoute.routeName: (context) => const BikeDetailsRoute()
        });
  }
}
