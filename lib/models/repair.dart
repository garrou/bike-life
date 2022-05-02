import 'package:intl/intl.dart';

class Repair {
  static DateFormat format = DateFormat('dd/MM/yyyy');

  final int id;
  final DateTime repairAt;
  final String reason;
  final double price;
  final String componentId;

  Repair(this.id, this.repairAt, this.reason, this.price, this.componentId);

  Map<String, dynamic> toJson() => {
        'id': id,
        'repairAt': repairAt.toString(),
        'reason': reason,
        'price': price,
        'componentId': componentId
      };

  Repair.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        repairAt = DateTime.parse(json['repairAt']),
        reason = json['reason'],
        price = json['price'].toDouble(),
        componentId = json['componentId'];

  String formatRepairAt() => format.format(repairAt);

  String formatPrice() => '${price.toStringAsFixed(2)} €';
}

List<Repair> createRepairs(List<dynamic> records) =>
    records.map((json) => Repair.fromJson(json)).toList(growable: false);
