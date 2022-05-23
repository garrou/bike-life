import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/diagnostic.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/models/tip.dart';
import 'package:bike_life/services/diagnostic_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/views/member/bike/bike_details.dart';
import 'package:bike_life/views/member/bike/bike_diagnostic_result.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:flutter/material.dart';

class BikeDiagnosticPage extends StatefulWidget {
  final Bike bike;
  const BikeDiagnosticPage({Key? key, required this.bike}) : super(key: key);

  @override
  State<BikeDiagnosticPage> createState() => _BikeDiagnosticPageState();
}

class _BikeDiagnosticPageState extends State<BikeDiagnosticPage> {
  late final Future<List<Diagnostic>> _diagnostics;
  late final List<Widget> _cards;
  final Map<int, bool> _responses = {};
  int _index = 0;

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
          if (snapshot.hasError) {
            return const AppError(message: 'Problème de connexion');
          } else if (snapshot.hasData) {
            _cards = snapshot.data!
                .map((diagnostic) => _buildDiagnosticCard(diagnostic))
                .toList();
            _cards.add(_buildLastCard(snapshot.data!));

            return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(secondSize),
                    child: Text(
                      'Diagnostique du vélo',
                      style: boldTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        secondSize, 0, secondSize, secondSize),
                    child: Text('$_index / ${snapshot.data!.length}',
                        style: secondTextStyle, textAlign: TextAlign.center),
                  ),
                  Expanded(child: IndexedStack(index: _index, children: _cards))
                ]);
          }
          return const AppLoading();
        },
      );

  Widget _buildDiagnosticCard(Diagnostic diagnostic) => Card(
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
                Padding(
                    child: Text(
                      diagnostic.title,
                      style: boldTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    padding: const EdgeInsets.all(secondSize)),
                Padding(
                  child: Text(
                    diagnostic.content,
                    style: secondTextStyle,
                    textAlign: TextAlign.center,
                  ),
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
                        setState(() {
                          _responses[diagnostic.id] = true;
                          _index++;
                        });
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

  Widget _buildLastCard(List<Diagnostic> diagnostics) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(children: <Widget>[
              for (Diagnostic diagnostic in diagnostics)
                Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(diagnostic.title, style: secondTextStyle),
                    trailing: _responses[diagnostic.id] == true
                        ? const Icon(Icons.check, color: primaryColor, size: 40)
                        : Icon(Icons.cancel_outlined,
                            color: Colors.red[900], size: 40),
                  ),
                )
            ]),
          ),
          AppButton(
            text: 'Valider',
            color: primaryColor,
            callback: _onSend,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      );

  void _onSend() async {
    final Map<String, bool> toSend =
        _responses.map((key, value) => MapEntry(key.toString(), value));
    final HttpResponse response =
        await DiagnosticService().sendDiagnostic(toSend);

    if (response.success()) {
      final List<Tip> tips = createTips(response.body()['tips']);

      if (tips.isEmpty) {
        showSuccessSnackBar(
            context, 'Bravo ! Votre vélo est en parfaite santé !');
        doublePush(context, const MemberHomePage(),
            BikeDetailsPage(bike: widget.bike));
      } else {
        push(context, BikeDiagnosticResultPage(tips: tips));
      }
    } else {
      showErrorSnackBar(context, response.message());
    }
  }
}
