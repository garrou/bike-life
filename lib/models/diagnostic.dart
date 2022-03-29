class Diagnostic {
  final int id;
  final String title;
  final String? type;
  final String component;
  final String content;

  Diagnostic(this.id, this.title, this.type, this.component, this.content);

  Diagnostic.fromJson(json)
      : id = json['id'],
        title = json['title'],
        type = json['type'],
        component = json['component'],
        content = json['content'];
}

List<Diagnostic> createDiagnostics(List<dynamic> records) =>
    records.map((json) => Diagnostic.fromJson(json)).toList(growable: false);
