import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/member/bike_card.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/widgets/top_right_button.dart';
import 'package:bike_life/widgets/card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AllBikesPage extends StatefulWidget {
  const AllBikesPage({Key? key}) : super(key: key);

  @override
  _AllBikesPageState createState() => _AllBikesPageState();
}

class _AllBikesPageState extends State<AllBikesPage> {
  final CarouselController _carouselController = CarouselController();
  final BikeRepository _bikeRepository = BikeRepository();
  final List<Widget> _cards = [];
  late int _memberId;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    await _getMemberId();
    await _loadBikes();
  }

  Future _getMemberId() async {
    int id = await Storage.getMemberId();
    setState(() {
      _memberId = id;
    });
  }

  Future _loadBikes() async {
    dynamic jsonBikes = await _bikeRepository.getBikes(_memberId);
    List<Bike> bikes = createSeveralBikes(jsonBikes['bikes']);
    Future.wait(bikes.map((bike) async => _cards.add(BikeCard(bike: bike))));

    setState(() {
      _cards.add(_buildAddBikeCard());
    });
  }

  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        AppTopRightButton(
            callback: () => Navigator.pushNamed(context, '/profile'),
            icon: Icons.person,
            padding: thirdSize),
        _buildCarousel()
      ]);

  Widget _buildCarousel() => SingleChildScrollView(
          child: Column(children: <Widget>[
        CarouselSlider(
          items: _cards,
          carouselController: _carouselController,
          options: CarouselOptions(
              enlargeCenterPage: true,
              height: MediaQuery.of(context).size.height - maxPadding,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _cards.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: intermediateSize,
                  height: intermediateSize,
                  margin: const EdgeInsets.symmetric(
                      vertical: thirdSize / 1.5, horizontal: thirdSize / 2),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? secondColor
                              : mainColor)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList())
      ]));

  Widget _buildAddBikeCard() => SizedBox(
      width: double.infinity,
      child: AppCard(
          child: IconButton(
              icon: const Icon(Icons.add, size: 50.0, color: mainColor),
              onPressed: () => Navigator.pushNamed(context, '/add-bike')),
          elevation: secondSize));
}
