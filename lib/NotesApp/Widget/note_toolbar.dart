import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

//Note Tool Bar
class NoteToolbar extends StatelessWidget {
  const NoteToolbar({
    super.key,
    required this.quillController,
  });

  final QuillController quillController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFD4A017),strokeAlign: BorderSide.strokeAlignOutside),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD4A017),
              offset: Offset(4, 4),
            )
          ]
      ),
      child: QuillSimpleToolbar(
        controller: quillController,
        config: QuillSimpleToolbarConfig(
          multiRowsDisplay: false, // এক লাইনে + scroll হবে

          showFontFamily: false,
          showFontSize: false,
          showSubscript: false,
          showSuperscript: false,
          showSmallButton: false,
          showInlineCode: false,
          showAlignmentButtons: false,
          showDirection: false,
          showHeaderStyle: false,
          showListCheck: false,
          showCodeBlock: false,
          showQuote: false,
          showIndent: false,
          showLink: false,

          buttonOptions: QuillSimpleToolbarButtonOptions(
            base: QuillToolbarBaseButtonOptions(
              iconSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}