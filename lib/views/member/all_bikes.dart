import 'dart:convert';

import 'package:bike_life/models/bike.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/member/add_bike.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AllBikesPage extends StatefulWidget {
  const AllBikesPage({Key? key}) : super(key: key);

  @override
  _AllBikesPageState createState() => _AllBikesPageState();
}

class _AllBikesPageState extends State<AllBikesPage> {
  final BikeService _bikeService = BikeService();
  late Future<List<Bike>> _bikes;
  final CarouselController _carouselController = CarouselController();
  int _current = 0;

  Future<List<Bike>> _loadBikes() async {
    String id = await Storage.getMemberId();
    Response response = await _bikeService.getBikes(id);

    if (response.statusCode == httpCodeOk) {
      return createBikes(jsonDecode(response.body));
    } else {
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
      body: Column(children: [
        Padding(
            padding: const EdgeInsets.only(top: secondSize),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: Text('Vélos', style: secondTextStyle)),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 40, 10),
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: ShapeDecoration(
                              color: deepGreen,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)))))
                ])),
        FutureBuilder<List<Bike>>(
            future: _bikes,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                List<Widget> cards =
                    snapshot.data!.map((bike) => _bikeCard(bike)).toList();
                return Column(children: [
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
                ]);
              }
              return const AppLoading();
            })
      ]));

  void _onGoAddBike() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => const AddBikePage()));

  Widget _bikeCard(Bike bike) => ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
          color: deepGreen,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: const EdgeInsets.all(thirdSize),
                child: Text(
                  bike.name,
                )),
          ),
          width: MediaQuery.of(context).size.width,
          height: 300));
}
