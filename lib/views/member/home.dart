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
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class HomPage extends StatefulWidget {
  const HomPage({Key? key}) : super(key: key);

  @override
  _HomPageState createState() => _HomPageState();
}

class _HomPageState extends State<HomPage> {
  final StreamController<bool> _authState = StreamController();
  late Future<List<Bike>> _bikes;

  @override
  void initState() {
    super.initState();
    Storage.checkIfLogged(_authState);
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
  Widget build(BuildContext context) => Scaffold(
        body: AuthGuard(
          authStream: _authState.stream,
          signedIn: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > maxWidth) {
              return _narrowLayout(constraints);
            } else {
              return _wideLayout(constraints);
            }
          }),
          signedOut: const SigninPage(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: _onAddBikePage,
          child: const Icon(Icons.add, color: Colors.white),
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
          return const AppError(message: 'Erreur serveur');
        } else if (snapshot.hasData) {
          return GridView.count(
            childAspectRatio: 0.7,
            controller: ScrollController(),
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

  void _onAddBikePage() =>
      Navigator.push(context, animationRightLeft(const AddBikePage()));
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
  Widget build(BuildContext context) => InkWell(
        onTap: () => Navigator.push(
            context, animationRightLeft(BikeDetailsPage(bike: widget.bike))),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Padding(
                    child: Text(widget.bike.name, style: setStyle(context, 20)),
                    padding: const EdgeInsets.all(10.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(widget.bike.type, style: setStyle(context, 18)),
                    const VerticalDivider(thickness: 2, width: 2),
                    widget.bike.electric
                        ? const Icon(Icons.electric_bike)
                        : const Icon(Icons.pedal_bike)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    widget.bike.electric
                        ? Text(
                            'Vélo électrique',
                            style: setStyle(context, 18),
                          )
                        : Text(
                            '',
                            style: setStyle(context, 18),
                          )
                  ],
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
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ComponentsAlerts(bike: widget.bike),
                ),
                Padding(
                  child: Image.asset('assets/bike.jpg', fit: BoxFit.contain),
                  padding: const EdgeInsets.only(top: 10.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextButton.icon(
                    label: Text('Ajouter des km', style: thirdTextStyle),
                    icon: const Icon(
                      Icons.add_road,
                      size: 20,
                    ),
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
                          borderRadius: BorderRadius.circular(20.0),
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
          text: 'Ajouter',
          callback: _onAddKm,
          icon: const Icon(Icons.add),
        )
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
