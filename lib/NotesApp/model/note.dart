class Note {
  Note({
    String? id,
    required this.title,
    required this.content,
    required this.contentJson,
    required this.dateCreated,
    required this.dateModified,
    required this.tags,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  final String id;
  final String? title;
  final String? content;
  final String contentJson;
  final int dateCreated;
  final int dateModified;
  final List<String>? tags;

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title ?? '',
    'content': content ?? '',
    'contentJson': contentJson,
    'dateCreated': dateCreated,
    'dateModified': dateModified,
    'tags': (tags ?? []).join('||'),
  };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'],
    title: map['title'],
    content: map['content'],
    contentJson: map['contentJson'],
    dateCreated: map['dateCreated'],
    dateModified: map['dateModified'],
    tags: (map['tags'] as String).isEmpty
        ? []
        : (map['tags'] as String).split('||'),
  );
}