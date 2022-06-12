import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/help/tips.dart';
import 'package:bike_life/views/member/home.dart';
import 'package:bike_life/views/member/profile/profile.dart';
import 'package:bike_life/views/member/statistics/statistics.dart';
import 'package:flutter/material.dart';

class MemberNav extends StatefulWidget {
  const MemberNav({Key? key}) : super(key: key);

  @override
  State<MemberNav> createState() => _MemberNavState();
}

class _MemberNavState extends State<MemberNav> {
  int _current = 0;
  final screens = [
    const MemberHomePage(),
    const StatisticsPage(),
    const TipsPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(
          children: screens,
          index: _current,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _current,
          onTap: (index) => setState(() => _current = index),
          backgroundColor: primaryColor,
          unselectedItemColor: Colors.white60,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bike_outlined),
              label: 'Vélos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              label: 'Statistiques',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outlined),
              label: 'Conseils',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Profil',
            ),
          ],
        ),
      );
}
