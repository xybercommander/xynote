import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:xynote/data/services/auth.dart';
import 'package:xynote/data/services/database.dart';
import 'package:xynote/views/auth/auth_fetch_page.dart';
import 'package:xynote/views/auth/google_auth_fetch_page.dart';
import 'package:xynote/views/auth/sign_up_page.dart';

import '../../data/providers/user_provider.dart';
import '../home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({ Key? key }) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  //------ VARIABLES ------//
  final _formKey = GlobalKey<FormState>();
  late Stream<QuerySnapshot> userStream;
  
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  //------ METHODS ------//
  void signIn() async {
    userStream = await databaseMethods.getUserInfoByEmail(_emailTextEditingController.text);                
    authMethods.signInWithEmailAndPassword(_emailTextEditingController.text, _passwordTextEditingController.text)
      .then((value) {        
        Navigator.pushReplacement(context, PageTransition(
          child: AuthFetchPage(userStream: userStream,),
          type: PageTransitionType.rightToLeft
        ));
      });
  }

  void googleSignIn() {
    authMethods.signInWithGoogle()
      .then((value) async {
        Provider.of<UserProvider>(context, listen: false).setEmail(value!.additionalUserInfo!.profile!['email']);
        Provider.of<UserProvider>(context, listen: false).setUsername(value.additionalUserInfo!.profile!['given_name']);
        Provider.of<UserProvider>(context, listen: false).setImageUrl(value.additionalUserInfo!.profile!['picture']);

        Stream<QuerySnapshot> userInfoSnapshot = await databaseMethods.getUserInfoByEmail(value.additionalUserInfo!.profile!['email']);           
        Navigator.pushReplacement(context, PageTransition(
          child: GoogleAuthFetchPage(
            userStream: userInfoSnapshot,
            email: value.additionalUserInfo!.profile!['email'],
            username: value.additionalUserInfo!.profile!['given_name'],
            imgUrl: value.additionalUserInfo!.profile!['picture'],
          ),
          type: PageTransitionType.rightToLeft
        ));
      });
  }


  //------ UI -------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailTextEditingController,
              ),
              TextFormField(
                controller: _passwordTextEditingController,
              ),
              SizedBox(height: 16,),
              MaterialButton(
                onPressed: () => signIn(),
                child: Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 18),),
                color: Colors.black,
              ),
              SizedBox(height: 4,),
              MaterialButton(
                onPressed: () => googleSignIn(),
                child: Text("Google", style: TextStyle(color: Colors.white, fontSize: 18),),
                color: Colors.blue,
              ),
              SizedBox(height: 4,),
              TextButton(
                onPressed: () => Navigator.pushReplacement(context, PageTransition(
                  child: SignUpPage(),
                  type: PageTransitionType.bottomToTop
                )), 
                child: Text("Sign Up", style: TextStyle(color: Colors.black),)
              ),              
            ],
          ),
        ),
      ),
    );
  }
}