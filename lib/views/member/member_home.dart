import 'dart:async';

import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/member/all_bikes.dart';
import 'package:bike_life/views/member/tips.dart';
import 'package:bike_life/styles/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class MemberHomePage extends StatefulWidget {
  const MemberHomePage({Key? key}) : super(key: key);

  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  int _pageIndex = 0;
  late PageController _pageController;
  final StreamController<bool> _authState = StreamController();

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthGuard(
      authStream: _authState.stream,
      signedIn: layout(),
      signedOut: const SigninPage());

  Widget layout() => Scaffold(
      body: PageView(
        children: const <Widget>[AllBikesPage(), TipsPage()],
        onPageChanged: (page) => setState(() => _pageIndex = page),
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _pageIndex,
        onTap: _onTabTapped,
        backgroundColor: mainColor,
        selectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.pedal_bike),
              label: 'Mes vélos',
              backgroundColor: mainColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment),
              label: 'Conseils',
              backgroundColor: mainColor)
        ],
      ));

  void _onTabTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
