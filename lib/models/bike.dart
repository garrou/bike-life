import 'package:intl/intl.dart';

class Bike {
  static DateFormat format = DateFormat('dd/MM/yyyy');

  final String id;
  final String name;
  final double kmPerWeek;
  final bool electric;
  final String type;
  final DateTime buyAt;
  final DateTime addedAt;
  final double totalKm;
  final bool automaticKm;

  Bike(this.id, this.name, this.kmPerWeek, this.electric, this.type, this.buyAt,
      this.addedAt, this.totalKm, this.automaticKm);

  Bike.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        kmPerWeek = json['kmPerWeek'].toDouble(),
        electric = json['electric'],
        type = json['type'],
        buyAt = DateTime.parse(json['buyAt']),
        addedAt = DateTime.parse(json['addedAt']),
        totalKm = json['totalKm'].toDouble(),
        automaticKm = json['automaticKm'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kmPerWeek': kmPerWeek,
        'electric': electric,
        'type': type,
        'buyAt': buyAt.toString(),
        'addedAt': addedAt.toString(),
        'totalKm': totalKm,
        'automaticKm': automaticKm
      };

  String formatBuyDate() => format.format(buyAt);

  String formatAddedDate() => format.format(addedAt);

  String formatKm() => totalKm.toStringAsFixed(2);
}

List<Bike> createBikes(List records) =>
    records.map((json) => Bike.fromJson(json)).toList(growable: false);
