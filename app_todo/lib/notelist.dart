
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_todo/addnote.dart';
import 'package:app_todo/dataasehelper.dart';
import 'package:app_todo/model.dart';

class NoteList extends StatefulWidget {

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
    int count = 0;

  @override
  Widget build(BuildContext context) {
    if(noteList == null){
      // ignore: deprecated_member_use
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        ),
      body: getNoteListView(),  

      floatingActionButton: FloatingActionButton(
        onPressed: () {
        debugPrint('fab click');
        navigateToDetail(Note('', '',), 'Add Note');
      },
       tooltip: 'Add Note',
       child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView(){
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 2.0,
          color: Colors.white,
          child: ListTile(
            title: Text(this.noteList[position].title, style: textStyle,),
            subtitle: Text(this.noteList[position].date),
            onTap: () {
              debugPrint("List Tapped");
              navigateToDetail(this.noteList[position], 'Edit Note');
            },
          ),
        );
      },
      );
  }

  // Navigate to Screen..//
  void navigateToDetail(Note note, String title) async{
   bool result =  await Navigator.push(context, MaterialPageRoute(builder: (context){
        return AddNote(note, title); 
        }));

       if(result == true){
         updateListView();
       } 
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
       Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
       noteListFuture.then((noteList){
         setState(() {
           this.noteList = noteList;
           this.count = noteList.length;
         });
       });
    });
  }
}