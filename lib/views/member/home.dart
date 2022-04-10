import 'dart:async';

import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/member/bike/bike_details.dart';
import 'package:bike_life/views/member/bike/bike_add.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

double height = 505.0;

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

  Widget _wideLayout() => const Center(
        child: SingleChildScrollView(
          child: Carousel(),
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
          return const AppError(message: 'Erreur serveur');
        } else if (snapshot.hasData) {
          List<Widget> cards =
              snapshot.data!.map((bike) => BikeCard(bike: bike)).toList();
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

  Widget _dotIndicator(int index) => InkWell(
        onTap: () => _onTap(index),
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
      );

  void _onTap(int index) => setState(() {
        _carouselController.animateToPage(index);
        _current = index;
      });
}

class BikeCard extends StatefulWidget {
  final Bike bike;
  const BikeCard({Key? key, required this.bike}) : super(key: key);

  @override
  State<BikeCard> createState() => _BikeCardState();
}

class _BikeCardState extends State<BikeCard> {
  final _keyForm = GlobalKey<FormState>();

  final _kmFocus = FocusNode();
  final _km = TextEditingController();

  @override
  Widget build(BuildContext context) => Material(
        borderRadius: BorderRadius.circular(10),
        color: primaryColor,
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      child: Text(
                        widget.bike.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: secondSize,
                        ),
                      ),
                      padding: const EdgeInsets.only(right: 10.0),
                    ),
                    widget.bike.electric
                        ? const Icon(Icons.electric_bike, color: Colors.white)
                        : const Icon(Icons.pedal_bike, color: Colors.white)
                  ],
                ),
                const Divider(color: Colors.white, thickness: 2.0),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '${widget.bike.formatKm()} km',
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextButton.icon(
                    label: const Text('Ajouter des km'),
                    icon: const Icon(
                      Icons.add_road,
                      size: 20,
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildAddKmPopup(context),
                    ),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                ComponentsAlerts(bike: widget.bike)
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: height,
          ),
          onTap: () => Navigator.push(
              context, animationRightLeft(BikeDetailsPage(bike: widget.bike))),
        ),
      );

  Widget _buildAddKmPopup(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter des kilomètres'),
      content: Form(
        key: _keyForm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppTextField(
              focusNode: _kmFocus,
              textfieldController: _km,
              validator: positiveValidator,
              hintText: 'Kilomètres à ajouter',
              label: 'Kilomètres',
              icon: Icons.add_road,
              keyboardType: TextInputType.number,
            )
          ],
        ),
      ),
      actions: <Widget>[
        AppButton(
            text: 'Ajouter', callback: _onAddKm, icon: const Icon(Icons.add))
      ],
    );
  }

  void _onAddKm() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _addKm();
    }
  }

  void _addKm() async {
    final HttpResponse response =
        await BikeService().addKm(widget.bike.id, double.parse(_km.text));

    if (response.success()) {
      Navigator.pushAndRemoveUntil(
          context,
          animationRightLeft(const MemberHomePage()),
          (Route<dynamic> route) => false);
      showSuccessSnackBar(context, response.message());
    } else {
      showErrorSnackBar(context, response.message());
    }
  }
}

class ComponentsAlerts extends StatefulWidget {
  final Bike bike;
  const ComponentsAlerts({Key? key, required this.bike}) : super(key: key);

  @override
  _ComponentsAlertsState createState() => _ComponentsAlertsState();
}

class _ComponentsAlertsState extends State<ComponentsAlerts> {
  late Future<int> _totalAlerts;

  Future<int> _loadNbAlerts() async {
    final HttpResponse response =
        await ComponentService().getComponentsAlerts(widget.bike.id);

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
          return const AppError(message: 'Erreur serveur');
        } else if (snapshot.hasData) {
          final int nb = snapshot.data!;
          final String s = nb > 1 ? 's' : '';

          return nb > 0
              ? TextButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BikeDetailsPage(bike: widget.bike),
                    ),
                  ),
                  label: Text(
                    nb > 0 ? '$nb composant$s à changer' : '',
                    style: thirdTextStyle,
                  ),
                  icon: const Icon(Icons.warning_amber),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(orange),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(color: orange),
                      ),
                    ),
                  ),
                )
              : const Text('');
        }
        return const AppLoading();
      });
}
