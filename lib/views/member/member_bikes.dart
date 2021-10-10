import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/routes/add_bike_route.dart';
import 'package:bike_life/routes/member_argument.dart';
import 'package:bike_life/views/member/add_bike.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/bike_tile.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemberBikesPage extends StatefulWidget {
  final Member member;
  const MemberBikesPage({Key? key, required this.member}) : super(key: key);

  @override
  _MemberBikesPageState createState() => _MemberBikesPageState();
}

class _MemberBikesPageState extends State<MemberBikesPage> {
  final BikeRepository _bikeRepository = BikeRepository();
  List<Bike> _bikes = [];

  void _loadBikes() async {
    dynamic jsonBikes = await _bikeRepository.getBikes(widget.member.id);
    setState(() {
      _bikes = createSeveralBikes(jsonBikes['bikes']);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBikes();
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
        body: ListView(children: <Widget>[
          const AppTitle(text: 'Mes vélos', paddingTop: 0.0),
          for (Bike bike in _bikes)
            AppBikeTile(bike: bike, member: widget.member)
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,
          splashColor: secondColor,
          onPressed: () => Navigator.pushNamed(context, AddBikeRoute.routeName,
              arguments: MemberArgument(widget.member)),
          tooltip: 'Ajouter un vélo',
          child: const Icon(Icons.add),
        ));
  }

  Route addBikeRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddBikePage(member: widget.member),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                .animate(CurvedAnimation(
              parent: animation,
              curve: Curves.ease,
            )),
            child: child,
          );
        });
  }
}
