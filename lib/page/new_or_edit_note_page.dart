import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notesapp/NotesApp/model/note.dart';
import 'package:notesapp/change_notifiers/new_note_controller.dart';
import 'package:notesapp/change_notifiers/notes_provider.dart';
import 'package:notesapp/NotesApp/Widget/note_toolbar.dart';
import 'package:notesapp/NotesApp/component/note_icon_button.dart';
import 'package:notesapp/NotesApp/component/note_icon_button_outlined.dart';
import 'package:provider/provider.dart';

class NewOrEditNotePage extends StatefulWidget {
  const NewOrEditNotePage({super.key, required this.isNewNote});

  final bool isNewNote;

  @override
  State<NewOrEditNotePage> createState() => _NewOrEditNotePageState();
}

class _NewOrEditNotePageState extends State<NewOrEditNotePage> {
  late QuillController quillController;
  late FocusNode focusNode;
  final TextEditingController tagController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final newNoteController = context.read<NewNoteController>();
    newNoteController.readOnly = !widget.isNewNote;

    quillController = QuillController(
      document: newNoteController.content,
      selection: const TextSelection.collapsed(offset: 0),
    );

    quillController.addListener(() {
      newNoteController.content = quillController.document;
    });

    titleController.text = newNoteController.title;

    focusNode = FocusNode();
    if (!newNoteController.readOnly) focusNode.requestFocus();
  }

  @override
  void dispose() {
    quillController.dispose();
    focusNode.dispose();
    tagController.dispose();
    titleController.dispose();
    super.dispose();
  }

  String _formatDate(int milliseconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}, $hour:$minute $period';
  }

  Future<void> _saveNote() async {
    final newNoteController = context.read<NewNoteController>();
    final notesProvider = context.read<NotesProvider>();

    final now = DateTime.now().millisecondsSinceEpoch;

    final note = Note(
      title: newNoteController.title,
      content: newNoteController.plainText,
      contentJson: newNoteController.contentJson,
      dateCreated: widget.isNewNote
          ? now
          : (newNoteController.editingId != null
          ? notesProvider.notes.firstWhere((n) => n.id == newNoteController.editingId!).dateCreated
          : now),
      dateModified: now,
      tags: newNoteController.tags,
    );

    if (widget.isNewNote) {
      await notesProvider.addNote(note);
    } else if (newNoteController.editingId != null) {
      await notesProvider.updateNoteById(newNoteController.editingId!, note);
    }

    Navigator.pop(context);
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final newNoteController = context.watch<NewNoteController>();

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NoteIconButtonOutlined(
            icon: Icons.arrow_back_ios_sharp,
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        title: Text(
          widget.isNewNote ? 'New Note' : 'Edit Note',
          style: const TextStyle(
            color: Color(0xFFD4A017),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          NoteIconButtonOutlined(
            icon: newNoteController.readOnly
                ? Icons.edit
                : Icons.menu_book_sharp,
            onPressed: () {
              newNoteController.readOnly = !newNoteController.readOnly;
              final document = quillController.document;
              final selection = quillController.selection;
              quillController = QuillController(
                document: document,
                selection: selection,
              );
              if (!newNoteController.readOnly) {
                focusNode.requestFocus();
              } else {
                FocusScope.of(context).unfocus();
              }
              setState(() {});
            },
          ),
          NoteIconButtonOutlined(
            icon: Icons.check,
            onPressed: newNoteController.hasContent ? () { _saveNote(); } : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Title
            TextField(
              readOnly: newNoteController.readOnly,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Title here',
                hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                border: InputBorder.none,
              ),
              controller: titleController,
              onChanged: (v) => newNoteController.title = v,
            ),

            // Date info  only when editing, shown below title
            if (!widget.isNewNote && newNoteController.editingId != null)
              Consumer<NotesProvider>(
                builder: (context, notesProvider, _) {
                  final note = notesProvider.notes[newNoteController.editingIndex!];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: [
                        _infoRow('Last Modified', _formatDate(note.dateModified)),
                        const SizedBox(height: 4),
                        _infoRow('Created', _formatDate(note.dateCreated)),
                      ],
                    ),
                  );
                },
              ),

            // Tags row
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Row(
                    children: [
                      Text(
                        'Tags',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (!newNoteController.readOnly)
                        NoteIconButton(
                          icon: Icons.add_circle,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => Center(
                                child: Material(
                                  child: Container(
                                    width: 300,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Add Tag'),
                                        TextField(
                                          controller: tagController,
                                          maxLength: 16,
                                          decoration: const InputDecoration(
                                            hintText: 'Add tag (<16 chars)',
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            final tag = tagController.text.trim();
                                            if (tag.isNotEmpty) {
                                              newNoteController.addTag(tag);
                                            }
                                            tagController.clear();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Add'),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: newNoteController.tags
                          .map(
                            (t) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: newNoteController.readOnly
                                ? null
                                : () {
                              tagController.text = t;
                              showDialog(
                                context: context,
                                builder: (_) => Center(
                                  child: Material(
                                    child: Container(
                                      width: 300,
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Edit Tag'),
                                          TextField(
                                            controller: tagController,
                                            maxLength: 16,
                                            decoration: const InputDecoration(
                                              hintText: 'Edit tag (<16 chars)',
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              final newTag = tagController.text.trim();
                                              if (newTag.isNotEmpty) {
                                                newNoteController.editTag(t, newTag);
                                              }
                                              tagController.clear();
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Save'),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Chip(
                              label: Text(t, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                              labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: Colors.grey.shade200,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              onDeleted: newNoteController.readOnly
                                  ? null
                                  : () => newNoteController.removeTag(t),
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),

            const Divider(thickness: 2),

            // Quill Editor
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: QuillEditor(
                      controller: quillController,
                      focusNode: focusNode,
                      scrollController: ScrollController(),
                      config: const QuillEditorConfig(
                        placeholder: 'Note here...',
                        expands: true,
                      ),
                    ),
                  ),
                  if (!newNoteController.readOnly)
                    NoteToolbar(quillController: quillController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}