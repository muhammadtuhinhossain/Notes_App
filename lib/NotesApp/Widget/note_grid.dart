import 'package:flutter/material.dart';
import 'package:notesapp/NotesApp/model/note.dart';
import 'note_card.dart';

class NotesGrid extends StatelessWidget {
  const NotesGrid({super.key, required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: notes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, int index) {
        return NoteCard(
          note: notes[index],
          isInGrid: true,
          index: index,
        );
      },
    );
  }
}