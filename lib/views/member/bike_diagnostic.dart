import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/diagnostic.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/models/tip.dart';
import 'package:bike_life/services/diagnostic_service.dart';
import 'package:bike_life/services/tip_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/tip_details.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:bike_life/widgets/click_region.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:flutter/material.dart';

class BikeDiagnostic extends StatefulWidget {
  final Bike bike;
  const BikeDiagnostic({Key? key, required this.bike}) : super(key: key);

  @override
  State<BikeDiagnostic> createState() => _BikeDiagnosticState();
}

class _BikeDiagnosticState extends State<BikeDiagnostic> {
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

  Widget _wideLayout(BuildContext context) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: thirdSize),
        children: <Widget>[
          AppTopLeftButton(
              title: 'Diagnostique', callback: () => Navigator.pop(context)),
          FutureBuilder<List<Diagnostic>>(
            future: _diagnostics,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DisplayDiagnostics(diagnostics: snapshot.data!);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const AppLoading();
            },
          )
        ],
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
  Widget build(BuildContext context) => IndexedStack(
        index: _index,
        children: [
          for (Diagnostic diagnostic in widget.diagnostics)
            Column(children: <Widget>[
              Card(
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
                              if (_index < widget.diagnostics.length - 1) {
                                setState(() => _index++);
                              }
                            },
                            icon: const Icon(Icons.cancel_outlined),
                          ),
                          IconButton(
                            color: primaryColor,
                            iconSize: 40,
                            onPressed: () {
                              _responses[diagnostic.id] = true;
                              if (_index < widget.diagnostics.length - 1) {
                                setState(() => _index++);
                              }
                            },
                            icon: const Icon(Icons.check),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              if (diagnostic.type != null)
                DisplayComponentsTips(type: diagnostic.type!)
            ])
        ],
      );
}

class DisplayComponentsTips extends StatefulWidget {
  final String type;
  const DisplayComponentsTips({Key? key, required this.type}) : super(key: key);

  @override
  State<DisplayComponentsTips> createState() => _DisplayComponentsTipsState();
}

class _DisplayComponentsTipsState extends State<DisplayComponentsTips> {
  late Future<List<Tip>> _tips;

  @override
  void initState() {
    super.initState();
    _tips = _loadTips();
  }

  Future<List<Tip>> _loadTips() async {
    final HttpResponse response = await TipService().getByTopic(widget.type);

    if (response.success()) {
      return createTips(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Tip>>(
      future: _tips,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (Tip tip in snapshot.data!) _buildTip(tip)
              ]);
        }
        return const AppLoading();
      });

  Widget _buildTip(Tip tip) => Card(
        elevation: 5,
        child: GestureDetector(
          onTap: () => Navigator.push(
              context, animationRightLeft(TipDetailsPage(tip: tip))),
          child: ListTile(
            title: AppClickRegion(child: Text(tip.title)),
            subtitle: AppClickRegion(child: Text(tip.writeDate)),
          ),
        ),
      );
}
