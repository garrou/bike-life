import 'package:intl/intl.dart';

class Bike {
  static DateFormat format = DateFormat('dd/MM/yyyy');

  final String id;
  final String name;
  final double kmPerWeek;
  final bool electric;
  final String type;
  final DateTime addedAt;
  final double totalKm;
  final bool automaticKm;
  final double price;

  Bike(this.id, this.name, this.kmPerWeek, this.electric, this.type,
      this.addedAt, this.totalKm, this.automaticKm, this.price);

  Bike.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        kmPerWeek = json['kmPerWeek'].toDouble(),
        electric = json['electric'],
        type = json['type'],
        addedAt = DateTime.parse(json['addedAt']),
        totalKm = json['totalKm'].toDouble(),
        automaticKm = json['automaticKm'],
        price = json['price'].toDouble();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kmPerWeek': kmPerWeek,
        'electric': electric,
        'type': type,
        'addedAt': addedAt.toString(),
        'totalKm': totalKm,
        'automaticKm': automaticKm,
        'price': price
      };

  String formatAddedDate() => format.format(addedAt);

  String formatKm() => '${totalKm.toStringAsFixed(2)} km';
}

List<Bike> createBikes(List<dynamic> records) =>
    records.map((json) => Bike.fromJson(json)).toList(growable: false);
