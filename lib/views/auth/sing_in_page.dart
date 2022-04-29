import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:xynote/data/services/auth.dart';
import 'package:xynote/views/auth/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({ Key? key }) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  //------ VARIABLES ------//
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();

  AuthMethods authMethods = AuthMethods();

  //------ METHODS ------//
  void signIn() {
    authMethods.signInWithEmailAndPassword(_emailTextEditingController.text, _passwordTextEditingController.text)
      .then((value) {
        print("USER ID ------> " + value!.userId.toString());
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
              TextButton(
                onPressed: () => Navigator.pushReplacement(context, PageTransition(
                  child: SignUpPage(),
                  type: PageTransitionType.bottomToTop
                )), 
                child: Text("Sign Up", style: TextStyle(color: Colors.black),)
              )
            ],
          ),
        ),
      ),
    );
  }
}