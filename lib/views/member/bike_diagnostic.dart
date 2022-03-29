import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/diagnostic.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/diagnostic_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:flutter/material.dart';

class BikeDiagnosticPage extends StatefulWidget {
  final Bike bike;
  const BikeDiagnosticPage({Key? key, required this.bike}) : super(key: key);

  @override
  State<BikeDiagnosticPage> createState() => _BikeDiagnosticPageState();
}

class _BikeDiagnosticPageState extends State<BikeDiagnosticPage> {
  late Future<List<Diagnostic>> _diagnostics;
  late Map<int, bool> _responses;

  @override
  void initState() {
    super.initState();
    _diagnostics = _loadDiagnostics();
  }

  Future<List<Diagnostic>> _loadDiagnostics() async {
    final HttpResponse response =
        await DiagnosticService().getDiagnosticsByBikeType(widget.bike.type);

    if (response.success()) {
      return createDiagnostics(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > maxWidth) {
            return _narrowLayout(context);
          } else {
            return _wideLayout(context);
          }
        }),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => FutureBuilder<List<Diagnostic>>(
        future: _diagnostics,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _responses = {for (Diagnostic d in snapshot.data!) d.id: false};

            return Column(children: [
              Expanded(
                child: ListView.builder(
                  controller: ScrollController(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) =>
                      _buildCard(snapshot.data![index])),
                ),
              ),
              AppButton(
                  text: 'Envoyer',
                  callback: () {/* TODO: diagnostic */},
                  icon: const Icon(Icons.arrow_forward))
            ]);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const AppLoading();
        },
      );

  Widget _buildCard(Diagnostic diagnostic) => Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Padding(
                child: Text(diagnostic.title, style: boldTextStyle),
                padding: const EdgeInsets.all(20.0),
              ),
              Text(diagnostic.content, style: secondTextStyle),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    color: Colors.red[900],
                    iconSize: 40,
                    onPressed: () {
                      _responses[diagnostic.id] = true;
                    },
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                  IconButton(
                    color: primaryColor,
                    iconSize: 40,
                    onPressed: () {
                      _responses[diagnostic.id] = true;
                    },
                    icon: const Icon(Icons.check),
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
