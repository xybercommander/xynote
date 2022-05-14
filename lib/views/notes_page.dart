import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({ Key? key }) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  var items = [];

  //------ UI ------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: items.length + 1,
        itemBuilder: (BuildContext context, index) {
          if(index == 0) {
            return Text("Notes", style: TextStyle(color: Colors.black, fontSize: 20),);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}