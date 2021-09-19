import 'package:bike_life/constants.dart';
import 'package:bike_life/user/account.dart';
import 'package:bike_life/user/profil_page.dart';
import 'package:bike_life/user/shop.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AccountBottomBarPage extends StatelessWidget {
  const AccountBottomBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(title), backgroundColor: mainColor),
        body: const BuildBottomBar());
  }
}

class BuildBottomBar extends StatefulWidget {
  const BuildBottomBar({Key? key}) : super(key: key);

  @override
  _BuildBottomBarState createState() => _BuildBottomBarState();
}

class _BuildBottomBarState extends State<BuildBottomBar> {
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
      ),
    );
  }
}
