import 'dart:async';

import 'package:bike_life/constants.dart';
import 'package:bike_life/routes/bike_details_route.dart';
import 'package:bike_life/routes/component_details_route.dart';
import 'package:bike_life/utils/helper.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/member/add_bike.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/views/member/profile.dart';
import 'package:bike_life/views/member/tips.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final StreamController<bool> _authState = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    setState(() {
      _checkIfLogged();
    });
  }

  void _checkIfLogged() async {
    String? memberId = await Helper.getMemberId();

    if (memberId != null) {
      int.parse(memberId) > 0 ? _authState.add(true) : _authState.add(false);
    } else {
      _authState.add(false);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
          title: title,
          theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: mainColor,
              brightness: Brightness.light),
          initialRoute: '/',
          routes: {
            '/': (context) => AuthGuard(
                authStream: _authState.stream,
                signedIn: const MemberHomePage(),
                signedOut: const SigninPage()),
            '/login': (context) => const SigninPage(),
            '/signup': (context) => const SignupPage(),
            '/home': (context) => AuthGuard(
                authStream: _authState.stream,
                signedIn: const MemberHomePage(),
                signedOut: const SigninPage()),
            '/add-bike': (context) => AuthGuard(
                authStream: _authState.stream,
                signedIn: const AddBikePage(),
                signedOut: const SigninPage()),
            '/profile': (context) => AuthGuard(
                authStream: _authState.stream,
                signedIn: const ProfilePage(),
                signedOut: const SigninPage()),
            '/tips': (context) => AuthGuard(
                authStream: _authState.stream,
                signedIn: const TipsPage(),
                signedOut: const SigninPage()),
            ComponentDetailsRoute.routeName: (context) => AuthGuard(
                authStream: _authState.stream,
                signedIn: const ComponentDetailsRoute(),
                signedOut: const SigninPage()),
            BikeDetailsRoute.routeName: (context) => AuthGuard(
                authStream: _authState.stream,
                signedIn: const BikeDetailsRoute(),
                signedOut: const SigninPage()),
          });
}
