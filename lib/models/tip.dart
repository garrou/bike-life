import 'package:intl/intl.dart';

class Tip {
  static DateFormat format = DateFormat('dd/MM/yyyy');

  final int id;
  final String componentType;
  final String title;
  final String content;
  final String writeDate;

  // TODO; check date

  Tip(this.id, this.componentType, this.title, this.content, this.writeDate);

  Tip.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        componentType = json['type'],
        title = json['title'],
        content = json['content'],
        writeDate = format.format(DateTime.parse(json['date']));
}

List<Tip> createTips(List records) {
  return records.map((json) => Tip.fromJson(json)).toList(growable: false);
}
