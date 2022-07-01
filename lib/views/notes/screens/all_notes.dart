import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:xynote/views/notes/providers/notes_provider.dart';
import 'package:xynote/views/notes/screens/note_typer.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({Key? key}) : super(key: key);

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  //------ VARIABLES ------//
  var items = [];

  //------ UI ------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<NotesProvider>(
        builder: (context, NotesProvider notesProvider, _) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(          
              physics: BouncingScrollPhysics(),
              itemCount: notesProvider.notes.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(notesProvider.notes[index - 1].content!),
                      Text(notesProvider.notes[index - 1].createdAt!.toString()),
                    ],
                  ),
                );
              },
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, PageTransition(
            child: NoteTyper(), type: PageTransitionType.rightToLeft
          ));
        },
        splashColor: Colors.white,
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
