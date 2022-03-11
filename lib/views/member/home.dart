import 'dart:async';

import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/member/add_bike.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/bike_components.dart';
import 'package:bike_life/widgets/click_region.dart';
import 'package:bike_life/views/member/bike_details.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

double height = 450.0;

class AllBikesPage extends StatefulWidget {
  const AllBikesPage({Key? key}) : super(key: key);

  @override
  _AllBikesPageState createState() => _AllBikesPageState();
}

class _AllBikesPageState extends State<AllBikesPage> {
  final StreamController<bool> _authState = StreamController();

  @override
  void initState() {
    super.initState();
    Storage.checkIfLogged(_authState);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AuthGuard(
            authStream: _authState.stream,
            signedIn: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > maxWidth) {
                return _narrowLayout(context);
              } else {
                return _wideLayout();
              }
            }),
            signedOut: const SigninPage()),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: _onAddBikePage,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8,
        ),
        child: _wideLayout(),
      );

  Widget _wideLayout() => Center(
        child: SingleChildScrollView(
          child: Column(
            children: const <Widget>[Carousel(), ComponentsAlerts()],
          ),
        ),
      );

  void _onAddBikePage() =>
      Navigator.push(context, animationRightLeft(const AddBikePage()));
}

class Carousel extends StatefulWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final CarouselController _carouselController = CarouselController();
  late Future<List<Bike>> _bikes;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _bikes = _loadBikes();
  }

  Future<List<Bike>> _loadBikes() async {
    final String memberId = await Storage.getMemberId();
    final HttpResponse response = await BikeService().getByMember(memberId);

    if (response.success()) {
      return createBikes(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Bike>>(
      future: _bikes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppError(message: '${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Widget> cards =
              snapshot.data!.map((bike) => _bikeCard(bike)).toList();
          return _buildCarousel(cards);
        }
        return const AppLoading();
      });

  Widget _buildCarousel(List<Widget> cards) => Column(
        children: <Widget>[
          CarouselSlider(
            items: cards,
            carouselController: _carouselController,
            options: CarouselOptions(
              onPageChanged: (index, _) {
                setState(() => _current = index);
              },
              height: height,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
            ),
          ),
          SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: cards.length,
              itemBuilder: (_, i) => _dotIndicator(i),
            ),
          ),
        ],
      );

  Widget _bikeCard(Bike bike) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: primaryColor,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    child: Text(
                      bike.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: secondSize,
                      ),
                    ),
                    padding: const EdgeInsets.only(right: 10),
                  ),
                  if (bike.electric)
                    const Icon(
                      Icons.electric_bike,
                      color: Colors.white,
                    ),
                ],
              ),
              const Divider(color: Colors.white, thickness: 2.0),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '${bike.formatKm()} km',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: secondSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  'assets/bike.jpg',
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.settings,
                      size: 30,
                    ),
                    onPressed: () => _updateBikePage(bike),
                    color: Colors.white,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.info_outline,
                      size: 30,
                    ),
                    onPressed: () => _onBikePage(bike),
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: height,
        ),
      );

  Widget _dotIndicator(int index) => GestureDetector(
        onTap: () => _onTap(index),
        child: AppClickRegion(
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
          ),
        ),
      );

  void _onTap(int index) => setState(() {
        _carouselController.animateToPage(index);
        _current = index;
      });

  void _updateBikePage(Bike bike) =>
      Navigator.push(context, animationRightLeft(BikeDetails(bike: bike)));

  void _onBikePage(Bike bike) => Navigator.push(
      context, animationRightLeft(BikeComponentsPage(bike: bike)));
}

class ComponentsAlerts extends StatefulWidget {
  const ComponentsAlerts({Key? key}) : super(key: key);

  @override
  _ComponentsAlertsState createState() => _ComponentsAlertsState();
}

class _ComponentsAlertsState extends State<ComponentsAlerts> {
  late Future<int> _totalAlerts;

  Future<int> _loadNbAlerts() async {
    final String memberId = await Storage.getMemberId();
    final HttpResponse response =
        await ComponentService().getComponentsAlerts(memberId);

    if (response.success()) {
      return response.body()['total'];
    } else {
      throw Exception(response.message());
    }
  }

  @override
  void initState() {
    super.initState();
    _totalAlerts = _loadNbAlerts();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<int>(
      future: _totalAlerts,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppError(message: '${snapshot.error}');
        } else if (snapshot.hasData) {
          final int nb = snapshot.data!;
          final String s = nb > 1 ? 's' : '';

          return Text(
            nb > 0 ? '$nb composant$s à changer' : '',
            style: boldTextStyle,
          );
        }
        return const AppLoading();
      });
}
