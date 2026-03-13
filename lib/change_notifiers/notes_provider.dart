import 'package:flutter/cupertino.dart';
import 'package:notesapp/NotesApp/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesProvider extends ChangeNotifier {
  final List<Note> _notes = [];
  Database? _db;
  bool _isReady = false;

  List<Note> get notes => [..._notes];

  NotesProvider() {
    _initDB();
  }

  Future<void> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id TEXT PRIMARY KEY,
            title TEXT,
            content TEXT,
            contentJson TEXT,
            dateCreated INTEGER,
            dateModified INTEGER,
            tags TEXT
          )
        ''');
      },
    );

    _isReady = true;
    await _loadFromDB();
  }

  Future<void> _ensureReady() async {
    while (!_isReady) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _loadFromDB() async {
    final maps = await _db!.query('notes', orderBy: 'dateModified DESC');
    _notes.clear();
    _notes.addAll(maps.map((m) => Note.fromMap(m)).toList());
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _ensureReady();
    await _db!.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    _notes.insert(0, note);
    notifyListeners();
  }

  Future<void> updateNoteById(String id, Note note) async {
    await _ensureReady();
    await _db!.update('notes', note.toMap(),
        where: 'id = ?', whereArgs: [id]);
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
    }
  }

  Future<void> deleteNoteById(String id) async {
    await _ensureReady();
    await _db!.delete('notes', where: 'id = ?', whereArgs: [id]);
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}