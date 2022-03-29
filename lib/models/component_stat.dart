import 'dart:math' as math;

import 'package:flutter/material.dart';

class ComponentStat {
  final String label;
  final double value;
  final Color color;

  ComponentStat.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        value = json['value'].toDouble(),
        color =
            Colors.primaries[math.Random().nextInt(Colors.primaries.length)];

  ComponentStat(this.label, this.value, this.color);
}

List<ComponentStat> createComponentStats(List<dynamic> records) =>
    records.map((json) => ComponentStat.fromJson(json)).toList(growable: false);
