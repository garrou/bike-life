import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppError extends StatelessWidget {
  final String message;
  const AppError({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Lottie.asset('assets/network-error.json'),
          Container(
            padding: const EdgeInsets.all(thirdSize),
            decoration: const BoxDecoration(
              color: red,
              borderRadius: BorderRadius.all(Radius.circular(thirdSize)),
            ),
            child: Text(message),
          ),
        ],
      ),
    );
  }
}
