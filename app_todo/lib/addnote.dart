import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_todo/dataasehelper.dart';
import 'package:app_todo/model.dart';

class AddNote extends StatefulWidget {
   
 final String appBarTitle;
 final Note note;

  AddNote(this.note, this.appBarTitle);
  @override
  _AddNoteState createState() => _AddNoteState(this.note, this.appBarTitle );
  
}

class _AddNoteState extends State<AddNote> {

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _AddNoteState(this.note, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
             // ignore: missing_return
             onWillPop: () {
               navigateLastScreen();
             },
      child :Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            navigateLastScreen();
          }),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0),
        child: ListView(
          children: <Widget>[

            Padding(padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextField(
              controller: titleController,
              style: textStyle,
              onChanged: (value){
                debugPrint('Something change text field');
                updateTitle();
              },
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            ),

             Padding(padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextField(
              controller: descriptionController,
              style: textStyle,
              onChanged: (value){
                debugPrint('Something change text field');
                updateDescription();
              },
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            ),

            Padding(padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    onPressed: (){
                      setState(() {
                        debugPrint('button clicked');
                        _save();
                      });
                    },
                   color: Colors.lightGreen,
                   textColor: Colors.red,
                   child: Text('Save',
                   textScaleFactor: 1.5,
                   ),
                ),
                ),
                
              ],
            ),
            ),
          ],
        ),
        ),
    ),
    );
    
  }

  void navigateLastScreen(){
    Navigator.pop(context, true);
  }

  void updateTitle(){
    note.title = titleController.text;
  }

  void updateDescription(){
    note.description = descriptionController.text;
  }

  //save data
  void _save() async{

    navigateLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    
   int result; 
   if(note.id != null){
     result = await helper.updateNote(note);  //update note.
   }else{
     result = await helper.insertNote(note);  //insert note.
   }

   if(result != 0){
      _showAlertDialog('Status', 'Note Saved Successfully.');
   }else{
      _showAlertDialog('Status', 'Problem Saving Note!!');
   }
  }

  //Alert Dialog.//
  void _showAlertDialog(String title, String message){

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context,
              builder: (_) => alertDialog );

  }
}