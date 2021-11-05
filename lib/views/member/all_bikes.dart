import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/utils/helper.dart';
import 'package:bike_life/views/member/bike_card.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/top_right_button.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AllBikesPage extends StatefulWidget {
  const AllBikesPage({Key? key}) : super(key: key);

  @override
  _AllBikesPageState createState() => _AllBikesPageState();
}

class _AllBikesPageState extends State<AllBikesPage> {
  final BikeRepository _bikeRepository = BikeRepository();
  final List<Widget> _cards = [];
  late int _memberId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _getMemberId() async {
    String? id = await Helper.getMemberId();
    setState(() {
      _memberId = id != null ? int.parse(id) : 0;
    });
  }

  Future _loadBikes() async {
    dynamic jsonBikes = await _bikeRepository.getBikes(_memberId);
    List<Bike> _bikes = createSeveralBikes(jsonBikes['bikes']);
    Future.wait(_bikes.map((bike) async => _cards.add(BikeCard(bike: bike))));
    setState(() {
      _cards.add(_buildAddBikeCard());
    });
  }

  Future _load() async {
    await _getMemberId();
    await _loadBikes();
  }

  @override
  Widget build(BuildContext context) => ListView(children: <Widget>[
        AppTopRightButton(
            callback: () => Navigator.pushNamed(context, '/profile'),
            icon: Icons.person,
            padding: thirdSize),
        Center(child: _buildCarousel())
      ]);

  Widget _buildCarousel() => CarouselSlider.builder(
      options: CarouselOptions(
          height: MediaQuery.of(context).size.height - ratio,
          enableInfiniteScroll: false),
      itemCount: _cards.length,
      itemBuilder: (BuildContext context, int index, int realIndex) =>
          _cards.elementAt(index));

  Widget _buildAddBikeCard() => SizedBox(
      width: double.infinity,
      child: AppCard(
          child: IconButton(
              icon: const Icon(Icons.add, size: 50.0, color: mainColor),
              onPressed: () => Navigator.pushNamed(context, '/add-bike')),
          elevation: secondSize));
}
