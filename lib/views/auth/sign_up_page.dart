import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:xynote/data/providers/user_provider.dart';
import 'package:xynote/data/services/auth.dart';
import 'package:xynote/data/services/database.dart';
import 'package:xynote/views/auth/sign_in_page.dart';
import 'package:xynote/views/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  //------ VARIABLES ------//
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController _usernameTextEditingController = TextEditingController();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();
  TextEditingController _confirmPasswordTextEditingController = TextEditingController();

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  //------ METHODS ------//
  void signUp() {
    authMethods.signUpWithEmailAndPassword(_emailTextEditingController.text, _passwordTextEditingController.text)
      .then((value) {
        Map<String, dynamic> userMap = {
          "email": _emailTextEditingController.text,
          "username": _usernameTextEditingController.text
        };
        databaseMethods.uploadUserInfo(userMap);
        Provider.of<UserProvider>(context, listen: false).setEmail(_emailTextEditingController.text);
        Provider.of<UserProvider>(context, listen: false).setUsername(_usernameTextEditingController.text);
        Navigator.pushReplacement(context, PageTransition(
          child: HomePage(),
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
                controller: _usernameTextEditingController,
              ),
              TextFormField(
                controller: _emailTextEditingController,
              ),
              TextFormField(
                controller: _passwordTextEditingController,
              ),
              TextFormField(
                controller: _confirmPasswordTextEditingController,
              ),
              SizedBox(height: 16,),
              MaterialButton(
                onPressed: () => signUp(),
                child: Text("Sign up", style: TextStyle(color: Colors.white, fontSize: 18),),
                color: Colors.black,
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacement(context, PageTransition(
                  child: SignInPage(),
                  type: PageTransitionType.bottomToTop
                )), 
                child: Text("Sign In", style: TextStyle(color: Colors.black),)
              )
            ],
          ),
        ),
      ),
    );
  }
}