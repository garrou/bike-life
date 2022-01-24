class Tip {
  final int id;
  final String componentType;
  final String title;
  final String content;
  final String writeDate;

  Tip(this.id, this.componentType, this.title, this.content, this.writeDate);

  Tip.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        componentType = json['type'],
        title = json['title'],
        content = json['content'],
        writeDate = json['date'];
}

List<Tip> createTipsFromList(List records) {
  return records.map((json) => Tip.fromJson(json)).toList(growable: false);
}
