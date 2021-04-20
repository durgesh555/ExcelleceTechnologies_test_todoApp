import 'package:flutter/material.dart';
import 'package:app_todo/notelist.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notes",
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: NoteList()
    );
  }
}