import 'dart:async';
import 'dart:convert';

import 'package:bike_life/models/component_type.dart';
import 'package:bike_life/models/tip.dart';
import 'package:bike_life/services/component_types_service.dart';
import 'package:bike_life/services/tip_service.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/widgets/tip_card.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:http/http.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  final StreamController<bool> _authState = StreamController();
  final TipService _tipService = TipService();
  final ComponentTypesService _componentTypesService = ComponentTypesService();
  List<ComponentType> _componentTypes = [];
  List<Tip> _tips = [];
  String _typeValue = '%';

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
    _loadComponentTypes();
    _loadTips();
  }

  void _loadComponentTypes() async {
    Response response = await _componentTypesService.getTypes();

    if (response.statusCode == httpCodeOk) {
      setState(() {
        _componentTypes =
            createComponentTypesFromList(jsonDecode(response.body));
        _componentTypes.add(ComponentType('Tous', '%'));
        _componentTypes = _componentTypes.reversed.toList();
      });
    }
  }

  void _loadTips() async {
    Response response = await _tipService.getByType(_typeValue);

    if (response.statusCode == httpCodeOk) {
      setState(() {
        _tips = createTipsFromList(jsonDecode(response.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) => AuthGuard(
      authStream: _authState.stream,
      signedIn: Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: deepGreen,
              child: const Icon(Icons.list),
              onPressed: _onOpenPopUp),
          body: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > maxSize) {
              return _narrowLayout(context);
            } else {
              return _wideLayout(context);
            }
          })),
      signedOut: const SigninPage());

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        AppTitle(
            text: 'Conseils', paddingTop: mainSize, style: secondTextStyle),
        for (Tip tip in _tips) AppTipCard(tip: tip)
      ]);

  void _onOpenPopUp() => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(mainSize))),
            title: const Text('Filtrer'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                DropdownButton(
                    value: _typeValue,
                    onChanged: (String? value) {
                      setState(() {
                        _typeValue = value!;
                        _loadTips();
                      });
                    },
                    items: _componentTypes
                        .map<DropdownMenuItem<String>>(
                            (ComponentType componentType) => DropdownMenuItem(
                                child: Text(componentType.name,
                                    style: secondTextStyle),
                                value: componentType.value))
                        .toList()),
              ]);
            }),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Fermer'),
                child: const Text('Fermer',
                    style: TextStyle(
                        color: deepGreen, fontSize: intermediateSize)),
              ),
            ]);
      });
}
