import 'package:flutter/material.dart';
import 'package:notesapp/NotesApp/Widget/no_notes.dart';
import 'package:notesapp/NotesApp/component/note_fab.dart';
import 'package:notesapp/change_notifiers/new_note_controller.dart';
import 'package:notesapp/change_notifiers/notes_provider.dart';
import 'package:notesapp/page/new_or_edit_note_page.dart';
import 'package:provider/provider.dart';

import '../NotesApp/Widget/note_card.dart';
import '../NotesApp/Widget/notes_list.dart';
import '../NotesApp/Widget/note_grid.dart';
import '../NotesApp/component/note_icon_button.dart';
import '../NotesApp/component/note_icon_button_outlined.dart';
import '../NotesApp/component/search_field.dart';

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  final List<String> dropdownOptions = ['Date modified', 'Date created'];
  late String dropdownValue = dropdownOptions.first;
  bool isDescending = true;
  bool isGrid = true;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFFFFE0B2),
        title: const Text(
          'Notes Book',
          style: TextStyle(
            color: Color(0xFFD4A017),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          NoteIconButtonOutlined(icon: Icons.logout, onPressed: () {}),
        ],
      ),
      floatingActionButton: NoteFab(onPressed: () {
        final notesProvider = context.read<NotesProvider>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: notesProvider,
              child: ChangeNotifierProvider(
                create: (_) => NewNoteController(),
                child: const NewOrEditNotePage(isNewNote: true),
              ),
            ),
          ),
        );
      }),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          final notes = [...notesProvider.notes];
          notes.sort((a, b) {
            if (dropdownValue == 'Date modified') {
              return isDescending
                  ? b.dateModified.compareTo(a.dateModified)
                  : a.dateModified.compareTo(b.dateModified);
            } else {
              return isDescending
                  ? b.dateCreated.compareTo(a.dateCreated)
                  : a.dateCreated.compareTo(b.dateCreated);
            }
          });
          notes.retainWhere((note) {
            if (_searchQuery.isEmpty) return true;
            final q = _searchQuery.toLowerCase();
            final titleMatch = (note.title ?? '').toLowerCase().contains(q);
            final tagMatch = (note.tags ?? []).any((t) => t.toLowerCase().contains(q));
            return titleMatch || tagMatch;
          });
          if (notesProvider.notes.isEmpty) return const NoNotes();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      NoteIconButton(
                        icon: isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                        size: 18,
                        onPressed: () {
                          setState(() {
                            isDescending = !isDescending;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.sort, size: 18, color: Colors.grey.shade700),
                        ),
                        underline: const SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(10),
                        isDense: true,
                        items: dropdownOptions.map((e) => DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              Text(e),
                              if (e == dropdownValue)
                                const SizedBox(width: 8),
                              if (e == dropdownValue)
                                const Icon(Icons.check, size: 18),
                            ],
                          ),
                        )).toList(),
                        selectedItemBuilder: (context) => dropdownOptions.map((e) => Text(e)).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                      ),
                      const Spacer(),
                      NoteIconButton(
                        icon: isGrid ? Icons.grid_view : Icons.menu,
                        size: 18,
                        onPressed: () {
                          setState(() {
                            isGrid = !isGrid;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    child: notes.isEmpty
                        ? Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                        : isGrid
                        ? NotesGrid(notes: notes)
                        : NotesList(notes: notes),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
