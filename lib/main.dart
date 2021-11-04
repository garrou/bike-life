import 'dart:async';

import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/member_repository.dart';
import 'package:bike_life/routes/add_bike_route.dart';
import 'package:bike_life/routes/bike_details_route.dart';
import 'package:bike_life/routes/component_details_route.dart';
import 'package:bike_life/routes/member_home_route.dart';
import 'package:bike_life/routes/profile_page_route.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/views/member/tips.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final StreamController<bool> _authState = StreamController();
  final MemberRepository _memberRepository = MemberRepository();
  Member? member;

  @override
  void initState() {
    super.initState();
    setState(() {
      _checkIfLogged();
    });
  }

  void _checkIfLogged() async {
    String? memberId =
        await const FlutterSecureStorage().read(key: 'member_id');

    if (memberId != null) {
      member = await _memberRepository.getMemberById(int.parse(memberId));
      member != null ? _authState.add(true) : _authState.add(false);
    } else {
      _authState.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AuthGuard(
          authStream: _authState.stream,
          signedIn: member != null
              ? MemberHomePage(member: member!)
              : const HomePage(),
          signedOut: const SigninPage(),
        ),
        title: title,
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: mainColor,
            brightness: Brightness.light),
        // initialRoute: '/',
        routes: {
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
