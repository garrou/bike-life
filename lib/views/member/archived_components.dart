import 'dart:async';
import 'dart:convert';

import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/component_type.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/services/component_types_service.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:http/http.dart';

class ArchivedComponentsPage extends StatefulWidget {
  const ArchivedComponentsPage({Key? key}) : super(key: key);

  @override
  _ArchivedComponentsPageState createState() => _ArchivedComponentsPageState();
}

class _ArchivedComponentsPageState extends State<ArchivedComponentsPage> {
  final StreamController<bool> _authState = StreamController();
  final ComponentService _componentService = ComponentService();
  final ComponentTypesService _componentTypesService = ComponentTypesService();
  List<Component> _components = [];
  List<ComponentType> _componentTypes = [];
  bool? _checked = false;
  String _typeValue = '%';

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
    _loadComponentTypes();
    _loadComponents();
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

  void _loadComponents() async {
    String memberId = await Storage.getMemberId();
    Response response = await _componentService.getMemberComponents(
        memberId, _checked!, _typeValue);

    if (response.statusCode == httpCodeOk) {
      setState(() {
        _components = createComponentsFromList(jsonDecode(response.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: deepGreen,
          child: const Icon(Icons.list),
          onPressed: _onOpenPopUp),
      body: AuthGuard(
          authStream: _authState.stream,
          signedIn: _buildLayout(),
          signedOut: const SigninPage()));

  Widget _buildLayout() => Column(children: [
        AppTitle(
            text: 'Mes composants',
            paddingTop: mainSize,
            style: secondTextStyle),
        Expanded(
            child: GridView.count(
                padding: const EdgeInsets.fromLTRB(
                    thirdSize, thirdSize, thirdSize, thirdSize),
                crossAxisCount: 3,
                children: _components
                    .map((item) => Card(
                        child: Container(
                            child: Padding(
                                child: Text(item.type),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 0)),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(thirdSize)),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/green.png'))))))
                    .toList()))
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
              return Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Archivés', style: thirdTextStyle),
                      Checkbox(
                          fillColor: MaterialStateProperty.all(deepGreen),
                          value: _checked,
                          onChanged: (bool? value) {
                            setState(() {
                              _checked = value;
                              _loadComponents();
                            });
                          })
                    ]),
                DropdownButton(
                    value: _typeValue,
                    onChanged: (String? value) {
                      setState(() {
                        _typeValue = value!;
                        _loadComponents();
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
