import 'package:flutter/material.dart';
class NoteFab extends StatelessWidget {
  const NoteFab({
    super.key, this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(3, 3),
            )
          ]
      ),
      child: FloatingActionButton(onPressed: onPressed,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFD4A017),
        foregroundColor: Colors.white,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          // side: BorderSide(
          //   color: Colors.black,
          // ),
        ),

      ),
    );
  }
}