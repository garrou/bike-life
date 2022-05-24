import 'package:bike_life/views/member/help/help.dart';
import 'package:bike_life/views/member/home.dart';
import 'package:bike_life/views/member/profile/profile.dart';
import 'package:bike_life/views/member/statistics/statistics.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:flutter/material.dart';

class MemberHomePage extends StatefulWidget {
  final int initialIndex;
  const MemberHomePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  late final PageController _pageController;
  late int _pageIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _pageIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          children: const <Widget>[
            HomPage(),
            StatisticsPage(),
            HelpPage(),
            ProfilePage()
          ],
          onPageChanged: (page) {
            setState(() => _pageIndex = page);
          },
          controller: _pageController,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: primaryColor,
          currentIndex: _pageIndex,
          selectedItemColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: true,
          onTap: _onTabTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bike, size: 30),
              label: 'Mes vélos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart, size: 30),
              label: 'Statistiques',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help, size: 30),
              label: 'Conseils',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'Profil',
            ),
          ],
        ),
      );

  void _onTabTapped(int index) => _pageController.animateToPage(index,
      duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
}
