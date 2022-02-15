import 'package:intl/intl.dart';

class ComponentChange {
  static DateFormat format = DateFormat('dd/MM/yyyy');

  final String changeAt;
  final double km;

  ComponentChange(this.changeAt, this.km);

  ComponentChange.fromJson(Map<String, dynamic> json)
      : changeAt = format.format(DateTime.parse(json['label'])),
        km = double.parse(json['value']);
}

List<ComponentChange> createChanges(List<dynamic> records) => records
    .map((json) => ComponentChange.fromJson(json))
    .toList(growable: false);
