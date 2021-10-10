import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/views/member/account.dart';
import 'package:bike_life/views/member/member_bikes.dart';
import 'package:bike_life/views/member/profil.dart';
import 'package:bike_life/views/member/shop.dart';
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
          children: [
            MemberBikesPage(member: widget.member),
            AccountPage(member: widget.member),
            const ShopPage(),
            ProfilPage(member: widget.member)
          ],
          onPageChanged: _onPageChanged,
          controller: _pageController,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: _onTabTapped,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.pedal_bike),
                label: 'Mes vélos',
                backgroundColor: mainColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.gradient),
                label: 'Compte',
                backgroundColor: mainColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Marketplace',
                backgroundColor: mainColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
                backgroundColor: mainColor)
          ],
        ));
  }
}
