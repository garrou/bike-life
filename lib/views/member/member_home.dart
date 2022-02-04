import 'package:bike_life/views/member/home.dart';
import 'package:bike_life/views/member/compare.dart';
import 'package:bike_life/views/member/statistics.dart';
import 'package:bike_life/views/member/tips.dart';
import 'package:bike_life/styles/general.dart';
import 'package:flutter/material.dart';

class MemberHomePage extends StatefulWidget {
  final int initialPage;
  const MemberHomePage({Key? key, required this.initialPage}) : super(key: key);

  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  late PageController _pageController;
  late int _pageIndex;

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.initialPage;
    _pageController = PageController(initialPage: _pageIndex);
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
          AllBikesPage(),
          ComparePage(),
          StatisticsPage(),
          TipsPage()
        ],
        onPageChanged: (page) {
          setState(() => _pageIndex = page);
        },
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _pageIndex,
        onTap: _onTabTapped,
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_bike),
              label: 'Vélos',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows),
              label: 'Comparaison de composants',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistiques',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment),
              label: 'Conseils',
              backgroundColor: primaryColor)
        ],
      ));

  void _onTabTapped(int index) => _pageController.animateToPage(index,
      duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
}
