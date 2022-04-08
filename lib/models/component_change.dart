import 'package:intl/intl.dart';

class ComponentChange {
  static DateFormat format = DateFormat('dd/MM/yyyy');

  final DateTime changedAt;
  final double km;
  final double price;
  final String brand;

  ComponentChange(this.changedAt, this.km, this.price, this.brand);

  ComponentChange.fromJson(Map<String, dynamic> json)
      : changedAt = DateTime.parse(json['changedAt']),
        km = json['kmRealised'].toDouble(),
        price = json['price'].toDouble(),
        brand = json['brand'];

  Map<String, dynamic> toJson() => {
        'changedAt': changedAt.toString(),
        'kmRealised': km,
        'price': price,
        'brand': brand
      };

  String formatChangedAt() => format.format(changedAt);

  String formatKm() => km.toStringAsFixed(2);

  String formatPrice() => price.toStringAsFixed(2);
}

List<ComponentChange> createChanges(List<dynamic> records) => records
    .map((json) => ComponentChange.fromJson(json))
    .toList(growable: false);
