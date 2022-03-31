import 'package:intl/intl.dart';

class Tip {
  static DateFormat format = DateFormat('dd/MM/yyyy');

  final int id;
  final String? componentType;
  final String title;
  final String content;
  final String? videoUrl;

  Tip(this.id, this.componentType, this.title, this.content, this.videoUrl);

  Tip.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        componentType = json['type'],
        title = json['title'],
        content = json['content'],
        videoUrl = json['video'];
}

List<Tip> createTips(List<dynamic> records) =>
    records.map((json) => Tip.fromJson(json)).toList(growable: false);
