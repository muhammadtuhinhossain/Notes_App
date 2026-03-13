import 'package:flutter/material.dart';
import 'package:notesapp/NotesApp/model/note.dart';
import 'package:notesapp/change_notifiers/new_note_controller.dart';
import 'package:notesapp/change_notifiers/notes_provider.dart';
import 'package:notesapp/page/new_or_edit_note_page.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.isInGrid,
    required this.note,
    required this.index,
  });

  final bool isInGrid;
  final Note note;
  final int index;

  String _formatDate(int milliseconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final tags = note.tags ?? [];

    return GestureDetector(
      onTap: () {
        final newNoteController = NewNoteController();
        newNoteController.loadFromNote(
          id: note.id,
          title: note.title,
          contentJson: note.contentJson,
          tags: note.tags,
          index: index,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: newNoteController,
              child: const NewOrEditNotePage(isNewNote: false),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.orangeAccent, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent.withOpacity(0.4),
              offset: const Offset(0, 3),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              note.title?.isNotEmpty == true ? note.title! : 'Untitled',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 4),

            // Tags
            if (tags.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: tags
                      .map(
                        (tag) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade100,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      margin: const EdgeInsets.only(right: 4),
                      child: Text(
                        tag,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),

            // Body Text
            const SizedBox(height: 4),
            if (isInGrid)
              Expanded(
                child: Text(
                  note.content?.isNotEmpty == true ? note.content! : '',
                  style: TextStyle(color: Colors.grey.shade700),
                  overflow: TextOverflow.fade,
                ),
              )
            else
              Text(
                note.content?.isNotEmpty == true ? note.content! : '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade700),
              ),

            // Date & Delete button
            Row(
              children: [
                Text(
                  _formatDate(note.dateCreated),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete Note'),
                        content: const Text(
                            'Are you sure you want to delete this note?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<NotesProvider>().deleteNoteById(note.id);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Icon(Icons.delete, color: Colors.grey.shade500, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}