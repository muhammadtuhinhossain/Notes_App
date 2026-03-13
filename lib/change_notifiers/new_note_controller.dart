import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

class NewNoteController extends ChangeNotifier {
  bool readOnly = false;

  String? editingId;
  int? editingIndex;

  String _title = '';
  String get title => _title;
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  Document _content = Document();
  Document get content => _content;
  set content(Document value) {
    _content = value;
    notifyListeners();
  }

  final List<String> _tags = [];
  List<String> get tags => _tags;

  void addTag(String tag) {
    if (tag.isEmpty) return;
    _tags.add(tag);
    notifyListeners();
  }

  void removeTag(String tag) {
    _tags.remove(tag);
    notifyListeners();
  }

  void editTag(String oldTag, String newTag) {
    final index = _tags.indexOf(oldTag);
    if (index != -1) {
      _tags[index] = newTag;
      notifyListeners();
    }
  }

  void loadFromNote({
    required String id,
    required String? title,
    required String contentJson,
    required List<String>? tags,
    required int index,
  }) {
    editingId = id;
    editingIndex = index;
    _title = title ?? '';
    _content = Document.fromJson(jsonDecode(contentJson));
    _tags.clear();
    if (tags != null) _tags.addAll(tags);
    notifyListeners();
  }

  String get plainText => _content.toPlainText().trim();
  String get contentJson => jsonEncode(_content.toDelta().toJson());
  bool get hasContent => _title.trim().isNotEmpty || plainText.isNotEmpty;
}