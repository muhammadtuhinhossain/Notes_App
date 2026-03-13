import 'package:flutter/material.dart';
class NoteIconButton extends StatelessWidget {
  const NoteIconButton({super.key, required this.icon, required this.onPressed, this.size});

  final IconData icon;
  final double? size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return
      //arrow Button
      IconButton(onPressed: onPressed,
       icon: Icon(icon),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        constraints: BoxConstraints(),
        style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        iconSize: size,
        color: Colors.grey.shade700,
      );
  }
}
