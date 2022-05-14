import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';
import 'package:xynote/data/services/database.dart';
import 'package:xynote/views/accounts_page.dart';
import 'package:xynote/views/notes_page.dart';

import '../../data/helper/shared_preferences.dart';


class GoogleAuthFetchPage extends StatefulWidget {
  final Stream<QuerySnapshot> userStream;
  final String? email;
  final String? username;
  final String? imgUrl;
  const GoogleAuthFetchPage({ 
    Key? key, 
    required this.userStream, 
    this.email, 
    this.username, 
    this.imgUrl 
  }) : super(key: key);

  @override
  State<GoogleAuthFetchPage> createState() => __GoogleAuthFetchPageState();
}

class __GoogleAuthFetchPageState extends State<GoogleAuthFetchPage> {

  //------ VARIABLE ------//  
  int dataLength = 0;
  DatabaseMethods databaseMethods = DatabaseMethods();

  //------ UI ------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: widget.userStream,
        builder: (context, snapshot) {
          
          if (snapshot.hasData) dataLength = (snapshot.data! as QuerySnapshot).docs.length;            

          Future.delayed(Duration(seconds: 3), () {                        
            if (dataLength == 0) {      
              String uuid = Uuid().v4();        
              Map<String, dynamic> userMap = {
                "email": widget.email,
                "username": widget.username,
                "imgUrl": widget.imgUrl,
                'uuid': uuid
              };
              databaseMethods.uploadUserInfo(userMap);
            }
            SharedPref.saveLoggedInSharedPreference(true);
            SharedPref.saveEmailSharedPreference(widget.email!);
            SharedPref.saveUsernameSharedPreference(widget.username!);
            SharedPref.saveImgUrlSharedPreference(widget.imgUrl!);
            
            Navigator.pushReplacement(context, PageTransition(child: NotesPage(), type: PageTransitionType.rightToLeft));
          });

          return Center(
            child: CircularProgressIndicator(color: Colors.black,),
          );
        },         
      ),
    );
  }
}