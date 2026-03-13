import 'package:uuid/uuid.dart';

class Note {
  Note({
    String? id,
    required this.title,
    required this.content,
    required this.contentJson,
    required this.dateCreated,
    required this.dateModified,
    required this.tags,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String? title;
  final String? content;
  final String contentJson;
  final int dateCreated;
  final int dateModified;
  final List<String>? tags;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'contentJson': contentJson,
    'dateCreated': dateCreated,
    'dateModified': dateModified,
    'tags': tags ?? [],
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    contentJson: json['contentJson'],
    dateCreated: json['dateCreated'],
    dateModified: json['dateModified'],
    tags: List<String>.from(json['tags'] ?? []),
  );
}