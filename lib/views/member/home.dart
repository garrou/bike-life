import 'dart:async';

import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/services/bike_service.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/member/bike/bike_details.dart';
import 'package:bike_life/views/member/bike/bike_add.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ConnectionError { auth, connection }

class MemberHomePage extends StatefulWidget {
  const MemberHomePage({Key? key}) : super(key: key);

  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  late final Future<List<Bike>> _bikes;

  @override
  void initState() {
    _bikes = _loadBikes();
    super.initState();
  }

  Future<List<Bike>> _loadBikes() async {
    try {
      final HttpResponse response = await BikeService().getByMember();

      if (response.success()) {
        return createBikes(response.body());
      } else {
        throw Exception(ConnectionError.auth);
      }
    } on Exception catch (_) {
      throw Exception(ConnectionError.connection);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Accueil', style: secondTextStyle),
        ),
        body: ListView(
          children: <Widget>[
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > maxWidth) {
                  return _narrowLayout(constraints);
                } else {
                  return _wideLayout(constraints);
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () => push(context, const AddBikePage()),
          child: const Icon(Icons.add_outlined, color: Colors.white),
        ),
      );

  Widget _narrowLayout(BoxConstraints constraints) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8,
        ),
        child: _wideLayout(constraints),
      );

  Widget _wideLayout(BoxConstraints constraints) => FutureBuilder<List<Bike>>(
      future: _bikes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (snapshot.error == ConnectionError.auth) {
            disconnectAndRedirect(context);
          } else {
            return const AppError(message: 'Problème de connexion');
          }
        } else if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/bike.svg',
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          child: Text(
                            'Aucun vélo ! Pour en ajouter un, cliquer sur le +',
                            style: secondTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          padding: const EdgeInsets.all(secondSize),
                        )
                      ]),
                )
              : GridView.count(
                  controller: ScrollController(),
                  shrinkWrap: true,
                  childAspectRatio: 0.65,
                  crossAxisCount: constraints.maxWidth > maxWidth + 400
                      ? 3
                      : constraints.maxWidth > maxWidth
                          ? 2
                          : 1,
                  children: <Widget>[
                    for (Bike bike in snapshot.data!) BikeCard(bike: bike),
                  ],
                );
        }
        return const AppLoading();
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
  Widget build(BuildContext context) => Card(
        elevation: 5,
        child: InkWell(
          onTap: () => push(context, BikeDetailsPage(bike: widget.bike)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Padding(
                    child: Text(widget.bike.name,
                        style: setStyle(context, secondSize)),
                    padding: const EdgeInsets.all(thirdSize)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: thirdSize),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(widget.bike.type, style: setStyle(context, 18)),
                      const VerticalDivider(thickness: 2, width: 2),
                      widget.bike.electric
                          ? const Icon(Icons.electric_bike_outlined)
                          : const Icon(Icons.pedal_bike_outlined)
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(widget.bike.formatKm(),
                              style: setStyle(context, 18)),
                          Text('Parcourus', style: setStyle(context, 14))
                        ],
                      ),
                      const VerticalDivider(thickness: 2, width: 2),
                      Column(
                        children: <Widget>[
                          Text('${widget.bike.price}',
                              style: setStyle(context, 18)),
                          Text('Prix', style: setStyle(context, 14))
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ComponentsAlerts(bike: widget.bike),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'assets/bike.jpg',
                    height: MediaQuery.of(context).size.height / 3.8,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextButton.icon(
                    label: Text('Ajouter des km', style: thirdTextStyle),
                    icon: const Icon(Icons.add_road_outlined, size: secondSize),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildAddKmPopup(context, widget.bike),
                    ),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          colorByTheme(context)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(secondSize),
                          side: BorderSide(color: colorByTheme(context)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildAddKmPopup(BuildContext context, Bike bike) {
    void _addKm() async {
      final HttpResponse response =
          await BikeService().addKm(widget.bike.id, double.parse(_km.text));

      if (response.success()) {
        pushAndRemove(context, const MemberHomePage());
        showSuccessSnackBar(context, response.message());
      } else {
        showErrorSnackBar(context, response.message());
      }
    }

    void _onAddKm() {
      if (_keyForm.currentState!.validate()) {
        _keyForm.currentState!.save();
        _addKm();
      }
    }

    return AlertDialog(
      title: Text("Ajouter des kilomètres à '${bike.name}'"),
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
              label: 'Kilomètres à ajouter',
              icon: Icons.add_road_outlined,
              keyboardType: TextInputType.number,
            )
          ],
        ),
      ),
      actions: <Widget>[
        AppButton(
          text: 'Ajouter',
          callback: _onAddKm,
          icon: const Icon(Icons.add_outlined),
        )
      ],
    );
  }
}

class ComponentsAlerts extends StatefulWidget {
  final Bike bike;
  const ComponentsAlerts({Key? key, required this.bike}) : super(key: key);

  @override
  _ComponentsAlertsState createState() => _ComponentsAlertsState();
}

class _ComponentsAlertsState extends State<ComponentsAlerts> {
  late final Future<int> _totalAlerts;

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
          return const Text(
              'Impossible de récupérer le nombre de composants à changer');
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
                  icon: const Icon(Icons.warning_amber_outlined),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(orange),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(secondSize),
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
