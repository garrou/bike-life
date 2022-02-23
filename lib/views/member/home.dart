import 'dart:async';

import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
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
import 'package:bike_life/widgets/buttons/top_right_button.dart';
import 'package:bike_life/widgets/click_region.dart';
import 'package:bike_life/views/member/bike_details.dart';
import 'package:bike_life/widgets/component_card.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

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
            horizontal: MediaQuery.of(context).size.width / 8),
        child: _wideLayout(),
      );

  Widget _wideLayout() => ListView(
        padding: const EdgeInsets.fromLTRB(
            thirdSize, firstSize, thirdSize, thirdSize),
        children: const <Widget>[Carousel(), ComponentsAlerts()],
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
                height: 400,
                enlargeCenterPage: true,
                enableInfiniteScroll: false),
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

  Widget _bikeCard(Bike bike) => GestureDetector(
        onTap: () => _onBikePage(bike),
        child: AppClickRegion(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: primaryColor,
              child: Column(
                children: <Widget>[
                  AppTopRightButton(
                      icon: const Icon(Icons.info_outline,
                          size: firstSize, color: Colors.white),
                      padding: 0,
                      onPressed: () => _updateBikePage(bike)),
                  Padding(
                      child: Text(bike.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: secondSize)),
                      padding: const EdgeInsets.only(bottom: 10)),
                  IntrinsicHeight(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${bike.formatKm()} km',
                          style: const TextStyle(
                              color: Colors.white, fontSize: secondSize)),
                      const VerticalDivider(
                          thickness: 2, width: 2, color: Colors.white),
                      Text(bike.formatDate(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: secondSize))
                    ],
                  )),
                ],
              ),
              width: MediaQuery.of(context).size.width,
              height: 500,
            ),
          ),
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
  late Future<List<Component>> _components;

  Future<List<Component>> _loadComponentsAlerts() async {
    final String memberId = await Storage.getMemberId();
    final HttpResponse response =
        await ComponentService().getComponentsAlerts(memberId);

    if (response.success()) {
      return createComponents(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  void initState() {
    super.initState();
    _components = _loadComponentsAlerts();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Component>>(
      future: _components,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppError(message: '${snapshot.error}');
        } else if (snapshot.hasData) {
          final int nb = snapshot.data!.length;
          final String s = nb > 1 ? 's' : '';

          return Column(
            children: <Widget>[
              Text(nb > 0 ? '$nb composant$s à changer' : '',
                  style: thirdTextStyle),
              ListView.builder(
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) =>
                      AppComponentCard(component: snapshot.data![index]))
            ],
          );
        }
        return const AppLoading();
      });
}
