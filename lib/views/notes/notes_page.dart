import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:xynote/data/providers/notes_provider.dart';
import 'package:xynote/views/notes/note_typer.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //------ VARIABLES ------//
  var items = [];

  //------ UI ------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(          
          physics: BouncingScrollPhysics(),
          itemCount: Provider.of<NotesProvider>(context, listen: false).notes.length + 1,
          itemBuilder: (BuildContext context, index) {
            if (index == 0) {
              return Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Text(
                    "Notes",
                    style: TextStyle(color: Colors.black, fontSize: 40),
                  ));
            } else {
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
                    Text(Provider.of<NotesProvider>(context, listen: false).notes[index - 1].content!),
                    Text(Provider.of<NotesProvider>(context, listen: false).notes[index - 1].createdAt!.toString()),
                  ],
                ),
              );
            }
          },
        ),
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
