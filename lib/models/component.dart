import 'package:intl/intl.dart';

class Component {
  static DateFormat format = DateFormat('dd/MM/yyyy');

  final String id;
  final double duration;
  final String type;
  final bool active;
  final DateTime changedAt;

  Component(this.id, this.duration, this.type, this.active, this.changedAt);

  Component.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        duration = double.parse(json['duration']),
        type = json['type'],
        active = json['active'],
        changedAt = DateTime.parse(json['changedAt']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'duration': duration,
        'type': type,
        'active': active,
        'changedAt': changedAt.toString()
      };

  String changedAtToString() => format.format(changedAt);
}

List<Component> createComponents(List<dynamic> records) =>
    records.map((json) => Component.fromJson(json)).toList(growable: false);
