import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:xynote/data/providers/user_provider.dart';
import 'package:xynote/data/services/auth.dart';
import 'package:xynote/views/auth/sign_in_page.dart';

import '../data/helper/shared_preferences.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({ Key? key }) : super(key: key);

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {

  //------ VARIABLES ------//
  AuthMethods authMethods = AuthMethods();

  //------ UI ------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,        
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(Provider.of<UserProvider>(context, listen: false).imageUrl),
              backgroundColor: Colors.white,
              radius: 50,
            ),
            Text(Provider.of<UserProvider>(context, listen: false).email),
            Text(Provider.of<UserProvider>(context, listen: false).username),            
            SizedBox(height: 8,),
            MaterialButton(
              onPressed: () {
                authMethods.signOut();
                SharedPref.saveLoggedInSharedPreference(false);
                SharedPref.saveEmailSharedPreference('');
                SharedPref.saveUsernameSharedPreference('');
                SharedPref.saveImgUrlSharedPreference('');
                Navigator.pushReplacement(context, PageTransition(
                  child: SignInPage(),
                  type: PageTransitionType.leftToRight
                ));
              },
              child: Text("Sign Out", style: TextStyle(color: Colors.white),),
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}