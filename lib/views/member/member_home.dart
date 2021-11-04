import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/views/member/all_bikes.dart';
import 'package:bike_life/views/member/tips.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class MemberHomePage extends StatefulWidget {
  final Member member;
  const MemberHomePage({Key? key, required this.member}) : super(key: key);

  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  int _pageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > maxSize) {
        return narrowLayout();
      } else {
        return wideLayout();
      }
    });
  }

  Widget narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }

  Widget wideLayout() {
    return Scaffold(
        body: PageView(
          children: [AllBikesPage(member: widget.member), const TipsPage()],
          onPageChanged: _onPageChanged,
          controller: _pageController,
        ),
        bottomNavigationBar: BottomNavigationBar(
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
                icon: Icon(Icons.archive),
                label: 'Conseils',
                backgroundColor: mainColor)
          ],
        ));
  }

  void _onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
