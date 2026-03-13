import 'package:flutter/material.dart';
import 'package:notesapp/NotesApp/model/note.dart';
import 'package:notesapp/NotesApp/Widget/note_card.dart';

class NotesList extends StatelessWidget {
  const NotesList({super.key, required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: notes.length,
      clipBehavior: Clip.none,
      itemBuilder: (context, index) {
        return NoteCard(
          note: notes[index],
          isInGrid: false,
          index: index,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}