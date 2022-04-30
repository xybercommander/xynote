import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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

  final picker = ImagePicker();
  File? _image;
  String imgUrl = '';

  //------ METHODS ------//
  void signUp() async {
    if(_image != null) {
      await uploadPic();
    }

    authMethods.signUpWithEmailAndPassword(_emailTextEditingController.text, _passwordTextEditingController.text)
      .then((value) {        
        Map<String, dynamic> userMap = {
          "email": _emailTextEditingController.text,
          "username": _usernameTextEditingController.text,          
          'imgUrl': imgUrl != '' ? imgUrl : '',
        };
        databaseMethods.uploadUserInfo(userMap);
        Provider.of<UserProvider>(context, listen: false).setEmail(_emailTextEditingController.text);
        Provider.of<UserProvider>(context, listen: false).setUsername(_usernameTextEditingController.text);
        Provider.of<UserProvider>(context, listen: false).setImageUrl(imgUrl);
        Navigator.pushReplacement(context, PageTransition(
          child: HomePage(),
          type: PageTransitionType.rightToLeft
        ));
      });
  }

  Future getImage() async {
    PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(
            msg: 'No Image Picked!',
            textColor: Colors.white,
            backgroundColor: Colors.black
        );
      }      
    });
  }

  Future uploadPic() async {
    final file = _image;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child(file!.path);
    await reference.putFile(file);
    imgUrl = await reference.getDownloadURL();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(                    
                    backgroundImage: _image != null 
                        ? FileImage(_image!) 
                        : AssetImage("assets/images/profile_pic.jpg") as ImageProvider,
                    backgroundColor: Colors.white,
                    radius: 40,
                  ),
                  MaterialButton(
                    onPressed: () => getImage(),
                    child: Text("Add Image", style: TextStyle(color: Colors.white),),
                    color: Colors.black,
                  ),
                ],
              ),
              SizedBox(height: 4,),
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