import 'dart:async';
import 'dart:convert';

import 'package:bike_life/models/bike.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/member/add_bike.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/views/member/bike_details.dart';
import 'package:bike_life/views/member/update_bike.dart';
import 'package:bike_life/views/member/profile.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:http/http.dart';

class AllBikesPage extends StatefulWidget {
  const AllBikesPage({Key? key}) : super(key: key);

  @override
  _AllBikesPageState createState() => _AllBikesPageState();
}

class _AllBikesPageState extends State<AllBikesPage> {
  final StreamController<bool> _authState = StreamController();
  final CarouselController _carouselController = CarouselController();
  final BikeService _bikeService = BikeService();
  late Future<List<Bike>> _bikes;
  int _current = 0;

  Future<List<Bike>> _loadBikes() async {
    String memberId = await Storage.getMemberId();
    Response response = await _bikeService.getByMember(memberId);

    if (response.statusCode == httpCodeOk) {
      return createBikes(jsonDecode(response.body));
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
    _bikes = _loadBikes();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: _onAddBikePage,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: AuthGuard(
          authStream: _authState.stream,
          signedIn: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > maxSize) {
              return _narrowLayout();
            } else {
              return _wideLayout();
            }
          }),
          signedOut: const SigninPage()));

  Widget _narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout());

  Widget _wideLayout() => Column(children: [
        Padding(
            padding: const EdgeInsets.all(secondSize),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vélos', style: secondTextStyle),
                  IconButton(
                    icon: const Icon(Icons.person),
                    iconSize: 30,
                    onPressed: _onProfilePage,
                  )
                ])),
        FutureBuilder<List<Bike>>(
            future: _bikes,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                List<Widget> cards =
                    snapshot.data!.map((bike) => _bikeCard(bike)).toList();
                return _buildCarousel(cards);
              }
              return const AppLoading();
            })
      ]);

  void _onTap(int index) => setState(() {
        index > _current
            ? _carouselController.nextPage()
            : _carouselController.previousPage();
        _current = index;
      });

  void _onProfilePage() =>
      Navigator.push(context, _animationRightLeft(const ProfilePage()));

  void _onAddBikePage() =>
      Navigator.push(context, _animationRightLeft(const AddBikePage()));

  void _onUpdateBikePage(Bike bike) =>
      Navigator.push(context, _animationRightLeft(UpdateBikePage(bike: bike)));

  void _onBikePage(Bike bike) =>
      Navigator.push(context, _animationRightLeft(BikeDetailsPage(bike: bike)));

  Widget _dotIndicator(int index) => GestureDetector(
      onTap: () => _onTap(index),
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: 20.0,
            height: 20.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 1.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index
                  ? primaryColor
                  : const Color.fromRGBO(0, 0, 0, 0.4),
            ),
          )));

  Route _animationRightLeft(Widget destination) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );

  Widget _buildCarousel(List<Widget> cards) => Column(children: [
        CarouselSlider(
            items: cards,
            carouselController: _carouselController,
            options: CarouselOptions(
                onPageChanged: (index, _) {
                  setState(() => _current = index);
                },
                height: 200,
                enlargeCenterPage: true,
                enableInfiniteScroll: false)),
        SizedBox(
            height: 30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: cards.length,
                itemBuilder: (_, i) {
                  return _dotIndicator(i);
                })),
      ]);

  Widget _bikeCard(Bike bike) => GestureDetector(
      onTap: () => _onBikePage(bike),
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  color: primaryColor,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            bike.name,
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _onUpdateBikePage(bike))
                      ]),
                  width: MediaQuery.of(context).size.width,
                  height: 300))));
}
