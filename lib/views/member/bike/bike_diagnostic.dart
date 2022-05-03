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
            return DisplayDiagnostics(diagnostics: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const AppLoading();
        },
      );
}

class DisplayDiagnostics extends StatefulWidget {
  final List<Diagnostic> diagnostics;
  const DisplayDiagnostics({Key? key, required this.diagnostics})
      : super(key: key);

  @override
  State<DisplayDiagnostics> createState() => _DisplayDiagnosticsState();
}

class _DisplayDiagnosticsState extends State<DisplayDiagnostics> {
  int _index = 0;
  late Map<int, bool> _responses;

  @override
  void initState() {
    super.initState();
    _responses = {for (Diagnostic d in widget.diagnostics) d.id: false};
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          IndexedStack(
            index: _index,
            children: <Widget>[
              for (Diagnostic diagnostic in widget.diagnostics)
                _buildCard(diagnostic),
            ],
          ),
          AbsorbPointer(
            absorbing: _index != _responses.length,
            child: AppButton(
              text: 'Valider',
              color: _index == _responses.length ? primaryColor : Colors.grey,
              callback: () {},
              icon: const Icon(Icons.arrow_forward),
            ),
          )
        ],
      );

  Widget _buildCard(Diagnostic diagnostic) => Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(secondSize),
        ),
        elevation: 5,
        child: SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(secondSize),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Text('${_index + 1}', style: boldTextStyle),
                ),
                Padding(
                    child: Text(diagnostic.title, style: boldTextStyle),
                    padding: const EdgeInsets.all(secondSize)),
                Padding(
                  child: Text(diagnostic.content, style: secondTextStyle),
                  padding: const EdgeInsets.only(bottom: secondSize),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      color: Colors.red[900],
                      iconSize: 40,
                      onPressed: () {
                        _responses[diagnostic.id] = false;
                        setState(() => _index++);
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                    IconButton(
                      color: primaryColor,
                      iconSize: 40,
                      onPressed: () {
                        _responses[diagnostic.id] = true;
                        setState(() => _index++);
                      },
                      icon: const Icon(Icons.check),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  void _onSend() async {
    final HttpResponse response =
        await DiagnosticService().sendDiagnostic(_responses);
  }
}
