import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notesapp/change_notifiers/notes_provider.dart';
import 'package:provider/provider.dart';

import 'page/main_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=>NotesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        localizationsDelegates: const [
          FlutterQuillLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
        ],

        theme: ThemeData(
          // brightness: Brightness.dark,
          // primaryColor: Colors.blue,
          // primarySwatch: Colors.blue,
          // scaffoldBackgroundColor: Colors.grey,

          appBarTheme: AppBarTheme(
            //backgroundColor: Colors.orange,
            centerTitle: true,
          ),
          textTheme: TextTheme(
            bodySmall: TextStyle(fontSize: 18),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(fontSize: 18),
            labelStyle: TextStyle(fontSize: 18),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(15),
            // ),
          ),
        ),


        home: NotesApp(),
      ),
    );
  }
}
