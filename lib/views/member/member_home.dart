import 'package:bike_life/views/member/help/help.dart';
import 'package:bike_life/views/member/home.dart';
import 'package:bike_life/views/member/profile/profile.dart';
import 'package:bike_life/views/member/statistics/statistics.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class MemberHomePage extends StatefulWidget {
  final int initialIndex;
  const MemberHomePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  late int _pageIndex;
  late PageController _pageController;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.initialIndex;
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
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _pageIndex,
          color: primaryColor,
          backgroundColor: colorFollowTheme(context),
          buttonBackgroundColor: colorFollowTheme(context),
          onTap: (index) {
            setState(() => _pageIndex = index);
            _onTabTapped(index);
          },
          letIndexChange: (index) => true,
          items: <Widget>[
            Icon(Icons.directions_bike, size: 30, color: colorByTheme(context)),
            Icon(Icons.bar_chart, size: 30, color: colorByTheme(context)),
            Icon(Icons.help, size: 30, color: colorByTheme(context)),
            Icon(Icons.person, size: 30, color: colorByTheme(context)),
          ],
        ),
      );

  void _onTabTapped(int index) => _pageController.animateToPage(index,
      duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
}
