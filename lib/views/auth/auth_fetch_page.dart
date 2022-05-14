import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:xynote/views/accounts_page.dart';
import 'package:xynote/views/notes_page.dart';

import '../../data/helper/shared_preferences.dart';
import '../../data/providers/user_provider.dart';

class AuthFetchPage extends StatefulWidget {
  final Stream<QuerySnapshot> userStream;
  const AuthFetchPage({ Key? key, required this.userStream }) : super(key: key);

  @override
  State<AuthFetchPage> createState() => _AuthFetchPageState();
}

class _AuthFetchPageState extends State<AuthFetchPage> {

  //------ VARIABLE ------//
  DocumentSnapshot? documentSnapshot;

  //------ UI ------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: widget.userStream,
        builder: (context, snapshot) {

          if (snapshot.hasData) documentSnapshot = (snapshot.data! as QuerySnapshot).docs[0];
          Future.delayed(Duration(seconds: 3), () {
            Provider.of<UserProvider>(context, listen: false).setEmail(documentSnapshot!['email']);
            Provider.of<UserProvider>(context, listen: false).setUsername(documentSnapshot!['username']);
            Provider.of<UserProvider>(context, listen: false).setImageUrl(documentSnapshot!['imgUrl']);
            SharedPref.saveLoggedInSharedPreference(true);
            SharedPref.saveEmailSharedPreference(documentSnapshot!['email']);
            SharedPref.saveUsernameSharedPreference(documentSnapshot!['username']);
            SharedPref.saveImgUrlSharedPreference(documentSnapshot!['imgUrl']);
            
            Navigator.pushReplacement(context, PageTransition(child: NotesPage(), type: PageTransitionType.rightToLeft));
          });

          return Center(
            child: CircularProgressIndicator(),
          );
        },         
      ),
    );
  }
}