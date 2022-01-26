import 'dart:convert';

import 'package:bike_life/models/bike.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/member/add_bike.dart';
import 'package:bike_life/views/member/bike_card.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/views/member/profile.dart';
import 'package:bike_life/widgets/top_right_button.dart';
import 'package:bike_life/widgets/card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AllBikesPage extends StatefulWidget {
  const AllBikesPage({Key? key}) : super(key: key);

  @override
  _AllBikesPageState createState() => _AllBikesPageState();
}

class _AllBikesPageState extends State<AllBikesPage> {
  final CarouselController _carouselController = CarouselController();
  final BikeService _bikeService = BikeService();
  final List<Widget> _cards = [];
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _loadBikes();
  }

  _loadBikes() async {
    String id = await Storage.getMemberId();
    Response response = await _bikeService.getBikes(id);

    if (response.statusCode == httpCodeOk) {
      dynamic json = jsonDecode(response.body);
      Future.wait(createBikesFromList(json)
          .map((bike) async => _cards.add(BikeCard(bike: bike))));
      setState(() => _cards.add(_buildAddBikeCard()));
    } else {
      Storage.disconnect();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const SigninPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) => ListView(children: <Widget>[
        AppTopRightButton(
            callback: _onGoProfilePage,
            icon: Icons.person,
            padding: thirdSize,
            color: deepGreen),
        _buildCarousel()
      ]);

  void _onGoProfilePage() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => const ProfilePage()));

  Widget _buildCarousel() => SingleChildScrollView(
          child: Column(children: <Widget>[
        CarouselSlider(
          items: _cards,
          carouselController: _carouselController,
          options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() => _current = index);
              },
              enlargeCenterPage: true,
              height: MediaQuery.of(context).size.height - maxPadding,
              enableInfiniteScroll: false),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Visibility(
                  visible: _current >= 1,
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: grey),
                      onPressed: () {
                        _carouselController.previousPage();
                        setState(() => _current--);
                      })),
              Visibility(
                  visible: _current < _cards.length - 1,
                  child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: grey),
                      onPressed: () {
                        _carouselController.nextPage();
                        setState(() => _current++);
                      }))
            ])
      ]));

  Widget _buildAddBikeCard() => SizedBox(
      width: double.infinity,
      child: AppCard(
          child: IconButton(
              icon: const Icon(Icons.add, size: 50.0, color: deepGreen),
              onPressed: _onGoAddBike),
          elevation: secondSize));

  void _onGoAddBike() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => const AddBikePage()));
}
