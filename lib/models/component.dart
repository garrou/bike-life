import 'package:intl/intl.dart';

class Component {
  static DateFormat format = DateFormat('dd/MM/yyyy');

  final String id;
  final double duration;
  final String type;
  final bool active;
  final DateTime changedAt;
  final double totalKm;

  Component(this.id, this.duration, this.type, this.active, this.changedAt,
      this.totalKm);

  Component.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        duration = json['duration'].toDouble(),
        type = json['type'],
        active = json['active'],
        changedAt = DateTime.parse(json['changedAt']),
        totalKm = json['totalKm'].toDouble();

  Map<String, dynamic> toJson() => {
        'id': id,
        'duration': duration,
        'type': type,
        'active': active,
        'changedAt': changedAt.toString(),
        'totalKm': totalKm
      };

  String formatDate() => format.format(changedAt);

  String formatKm() => totalKm.toStringAsFixed(2);
}

List<Component> createComponents(List<dynamic> records) =>
    records.map((json) => Component.fromJson(json)).toList(growable: false);
