import 'package:intl/intl.dart';

class Change {
  static DateFormat format = DateFormat('dd/MM/yyyy');

  final String changeAt;
  final double km;

  Change(this.changeAt, this.km);

  Change.fromJson(Map<String, dynamic> json)
      : changeAt = format.format(DateTime.parse(json['changedAt'])),
        km = double.parse(json['km']);
}

List<Change> createChanges(List<dynamic> records) =>
    records.map((json) => Change.fromJson(json)).toList(growable: false);
