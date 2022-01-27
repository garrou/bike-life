import 'dart:convert';

import 'package:bike_life/models/bike.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/member/add_bike.dart';
import 'package:bike_life/widgets/bike_card.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/views/member/profile.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/top_right_button.dart';
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
  late Future<List<Bike>> _bikes;
  int _current = 0;

  Future<List<Bike>> _loadBikes() async {
    String id = await Storage.getMemberId();
    Response response = await _bikeService.getBikes(id);

    if (response.statusCode == httpCodeOk) {
      return createBikes(jsonDecode(response.body));
    } else {
      Storage.disconnect();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SigninPage()),
          (route) => false);
      throw Exception('Impossible de récupérer les données');
    }
  }

  @override
  void initState() {
    super.initState();
    _bikes = _loadBikes();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: deepGreen,
        onPressed: _onGoAddBike,
        child: const Icon(Icons.add),
      ),
      body: ListView(children: <Widget>[
        AppTopRightButton(
            callback: _onGoProfilePage,
            icon: Icons.person,
            padding: thirdSize,
            color: deepGreen),
        FutureBuilder<List<Bike>>(
            future: _bikes,
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                List<Widget> cards =
                    snapshot.data!.map((bike) => BikeCard(bike: bike)).toList();
                return _buildCarousel(cards);
              }
              return const AppLoading();
            }),
      ]));

  void _onGoProfilePage() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => const ProfilePage()));

  Widget _buildCarousel(List<Widget> cards) => SingleChildScrollView(
          child: Column(children: <Widget>[
        CarouselSlider(
          items: cards,
          carouselController: _carouselController,
          options: CarouselOptions(
              onPageChanged: (index, _) {
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
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        _carouselController.previousPage();
                        setState(() => _current--);
                      })),
              Visibility(
                  visible: _current < cards.length - 1,
                  child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        _carouselController.nextPage();
                        setState(() => _current++);
                      }))
            ])
      ]));

  void _onGoAddBike() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => const AddBikePage()));
}
