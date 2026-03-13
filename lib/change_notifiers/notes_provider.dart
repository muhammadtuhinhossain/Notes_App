import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:notesapp/NotesApp/model/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => [..._notes];

  NotesProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notes_list');
    if (data != null) {
      final List decoded = jsonDecode(data);
      _notes.clear();
      _notes.addAll(decoded.map((e) => Note.fromJson(e)).toList());
      notifyListeners();
    }
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'notes_list',
      jsonEncode(_notes.map((n) => n.toJson()).toList()),
    );
  }

  Future<void> addNote(Note note) async {
    _notes.add(note);
    notifyListeners();
    await _saveAll();
  }

  Future<void> updateNoteById(String id, Note note) async {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
      await _saveAll();
    }
  }

  Future<void> deleteNoteById(String id) async {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
    await _saveAll();
  }
}