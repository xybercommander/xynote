import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({ Key? key }) : super(key: key);

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
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: items.length + 1,
          itemBuilder: (BuildContext context, index) {
            if(index == 0) {
              return Container(
                margin: EdgeInsets.only(top: 32, left: 16),
                child: Text("Notes", style: TextStyle(color: Colors.black, fontSize: 40),)
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        splashColor: Colors.white,
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}