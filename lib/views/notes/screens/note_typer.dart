import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xynote/data/models/note_model.dart';
import 'package:xynote/data/providers/notes_provider.dart';

class NoteTyper extends StatefulWidget {
  const NoteTyper({Key? key}) : super(key: key);

  @override
  State<NoteTyper> createState() => _NoteTyperState();
}

class _NoteTyperState extends State<NoteTyper> {

  //------ VARIABLES ------//
  TextEditingController noteController = TextEditingController();

  //------ METHODS ------//

  //------ UI ------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 64, horizontal: 32),
          child: Column(
            children: [
              TextField(
                controller: noteController,
                scrollPadding: EdgeInsets.all(20),
                keyboardType: TextInputType.multiline,
                maxLines: 9999,
                autofocus: true,
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Note newNote = Note(content: noteController.text, createdAt: DateTime.now());
          Provider.of<NotesProvider>(context, listen: false).pushNewNote(newNote);
          await Future.delayed(Duration(seconds: 2));
          Navigator.pop(context);
        },
        icon: Icon(Icons.save),
        label: Text("Save")
      ),
    );
  }
}