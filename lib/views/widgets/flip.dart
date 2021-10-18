import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class AppFlip extends StatefulWidget {
  final Widget front;
  final Widget back;
  const AppFlip({Key? key, required this.front, required this.back})
      : super(key: key);

  @override
  _AppFlipState createState() => _AppFlipState();
}

class _AppFlipState extends State<AppFlip> {
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
