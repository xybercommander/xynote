import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  //------ VARIABLES ------//
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();

  //------ METHODS ------//
  


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
                onPressed: () => print(_emailTextEditingController.text + " " + _passwordTextEditingController.text),
                child: Text("Sign up", style: TextStyle(color: Colors.white, fontSize: 18),),
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}