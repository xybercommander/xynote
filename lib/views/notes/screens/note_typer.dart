import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:xynote/views/auth/providers/user_provider.dart';
import 'package:xynote/views/notes/models/note_model.dart';
import 'package:xynote/views/notes/providers/notes_provider.dart';
import 'package:xynote/views/notes/services/note_services.dart';

class NoteTyper extends StatefulWidget {
  const NoteTyper({Key? key}) : super(key: key);

  @override
  State<NoteTyper> createState() => _NoteTyperState();
}

class _NoteTyperState extends State<NoteTyper> {

  //------ VARIABLES ------//
  TextEditingController noteController = TextEditingController();
  NoteServices noteServices = NoteServices();

  //------ METHODS ------//

  //------ UI ------//
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, NotesProvider>(
      builder: (context, UserProvider userProvider, NotesProvider notesProvider, _) {
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
              String _id = Uuid().v1().toString();
              NoteModel noteModel = NoteModel(
                id: _id,
                content: noteController.text, 
                createdAt: DateTime.now()
              );
              noteServices.uploadNoteToDB(noteModel, userProvider.email, _id);
              // Provider.of<NotesProvider>(context, listen: false).pushNewNote(noteModel);
              // await Future.delayed(Duration(seconds: 2));
              Navigator.pop(context);
            },
            icon: Icon(Icons.save),
            label: Text("Save")
          ),
        );
      }
    );
  }
}