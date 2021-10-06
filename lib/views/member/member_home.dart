import 'package:bike_life/constants.dart';
import 'package:bike_life/views/member/account.dart';
import 'package:bike_life/views/member/profil.dart';
import 'package:bike_life/views/member/shop.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class MemberHome extends StatefulWidget {
  const MemberHome({Key? key}) : super(key: key);

  @override
  _MemberHomeState createState() => _MemberHomeState();
}

class _MemberHomeState extends State<MemberHome> {
  int _pageIndex = 0;
  late PageController _pageController;

  final List<Widget> _tabPages = [
    const AccountPage(),
    const ShopPage(),
    const ProfilPage(),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          children: _tabPages,
          onPageChanged: _onPageChanged,
          controller: _pageController,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: _onTabTapped,
          backgroundColor: Colors.white,
          selectedItemColor: mainColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
                backgroundColor: mainColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Marketplace'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ));
  }
}
