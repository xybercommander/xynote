import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:xynote/data/helper/shared_preferences.dart';
import 'package:xynote/data/providers/user_provider.dart';
import 'package:xynote/data/services/auth.dart';
import 'package:xynote/data/services/database.dart';
import 'package:xynote/views/auth/google_auth_fetch_page.dart';
import 'package:xynote/views/auth/sign_in_page.dart';
import 'package:xynote/views/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  //------ VARIABLES ------//
  bool showPassword = false;
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

    String uuid = Uuid().v4();

    authMethods.signUpWithEmailAndPassword(_emailTextEditingController.text, _passwordTextEditingController.text)
      .then((value) {        
        Map<String, dynamic> userMap = {
          "email": _emailTextEditingController.text,
          "username": _usernameTextEditingController.text,          
          'imgUrl': imgUrl != '' ? imgUrl : '',
          'uuid': uuid
        };
        databaseMethods.uploadUserInfo(userMap);
        Provider.of<UserProvider>(context, listen: false).setEmail(_emailTextEditingController.text);
        Provider.of<UserProvider>(context, listen: false).setUsername(_usernameTextEditingController.text);
        Provider.of<UserProvider>(context, listen: false).setImageUrl(imgUrl);
        SharedPref.saveLoggedInSharedPreference(true);
        SharedPref.saveEmailSharedPreference(_emailTextEditingController.text);
        SharedPref.saveUsernameSharedPreference(_usernameTextEditingController.text);
        SharedPref.saveImgUrlSharedPreference(imgUrl != '' ? imgUrl : '');
        
        Navigator.pushReplacement(context, PageTransition(
          child: HomePage(),
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Bg.PNG"),
            fit: BoxFit.cover
          )
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 56),
            color: Colors.white.withOpacity(0.8),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(                  
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage("assets/images/xynote_black.png")
                            )
                          ),
                        ),
                        Text("X y n o t e", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'RobotoSlabBold'),),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
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
                        SizedBox(height: 8,),
                        TextFormField(
                          controller: _usernameTextEditingController,
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                            prefixIcon: Image.asset("assets/icons/mail.png"),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5), 
                              borderSide: BorderSide(color: Colors.black, width: 2.5)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5), 
                              borderSide: BorderSide(color: Colors.black, width: 2.5)
                            ),
                          ),
                        ),
                        SizedBox(height: 12,),
                        TextFormField(
                          controller: _emailTextEditingController,
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                            prefixIcon: Image.asset("assets/icons/mail.png"),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5), 
                              borderSide: BorderSide(color: Colors.black, width: 2.5)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5), 
                              borderSide: BorderSide(color: Colors.black, width: 2.5)
                            ),
                          ),
                        ),
                        SizedBox(height: 12,),
                        TextFormField(
                          controller: _passwordTextEditingController,
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          cursorColor: Colors.black,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                            prefixIcon: Image.asset("assets/icons/lock.png"),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              }, 
                              icon: Image.asset(showPassword == false ? "assets/icons/eye.png" : "assets/icons/eye-off.png")
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5), 
                              borderSide: BorderSide(color: Colors.black, width: 2.5)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5), 
                              borderSide: BorderSide(color: Colors.black, width: 2.5)
                            ),
                          ),
                        ),
                        SizedBox(height: 12,),
                        TextFormField(
                          controller: _confirmPasswordTextEditingController,
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          cursorColor: Colors.black,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                            prefixIcon: Image.asset("assets/icons/lock.png"),                  
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5), 
                              borderSide: BorderSide(color: Colors.black, width: 2.5)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5), 
                              borderSide: BorderSide(color: Colors.black, width: 2.5)
                            ),
                          ),
                        ),
                        SizedBox(height: 16,),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            onPressed: () => signUp(),
                            child: Text("Sign up", style: TextStyle(color: Colors.white, fontSize: 18),),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                            onPressed: () => Navigator.pushReplacement(context, PageTransition(
                              child: SignInPage(),
                              type: PageTransitionType.bottomToTop
                            )),
                            child: Text("Sign in", style: TextStyle(color: Colors.black, fontSize: 18),)
                          ),
                        ),                        
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}