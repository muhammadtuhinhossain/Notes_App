import 'package:flutter/material.dart';

class NoNotes extends StatelessWidget {
  const NoNotes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/file1.png',width: MediaQuery.sizeOf(context).width *0.75,),
          SizedBox(height: 32,),
          Text('You have no notes yet!\nStart by creating the + button below',
            style: TextStyle(
                fontSize: 18,fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],),
    );
  }
}