import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class AppFlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  const AppFlipCard({Key? key, required this.front, required this.back})
      : super(key: key);

  @override
  _AppFlipCardState createState() => _AppFlipCardState();
}

class _AppFlipCardState extends State<AppFlipCard> {
  @override
  Widget build(BuildContext context) {
    return FlipCard(
        fill: Fill.fillBack,
        flipOnTouch: true,
        direction: FlipDirection.HORIZONTAL,
        front: widget.front,
        back: widget.back);
  }
}
