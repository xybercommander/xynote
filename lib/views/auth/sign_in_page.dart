import 'dart:ui';

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
  bool showPassword = false;
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
      body: SingleChildScrollView(
        child: Container(
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
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
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
                          SizedBox(height: 16,),
                          SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              onPressed: () => signIn(),
                              child: Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 18),),
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4,),
                          SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                              onPressed: () => Navigator.pushReplacement(context, PageTransition(
                                child: SignUpPage(),
                                type: PageTransitionType.bottomToTop
                              )),                 
                              child: Text("Sign Up", style: TextStyle(color: Colors.black, fontSize: 18),)
                            ),
                          ),
                          SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 2,
                                width: MediaQuery.of(context).size.width / 3.5,
                                color: Colors.black,
                              ),
                              Text("OR", style: TextStyle(color: Colors.black, fontSize: 26, fontFamily: 'RobotoSlabBold'),),
                              Container(
                                height: 2,
                                width: MediaQuery.of(context).size.width / 3.5,                  
                                color: Colors.black,
                              ),
                            ],
                          ),
                          SizedBox(height: 16,),
                          InkWell(
                            onTap: () => googleSignIn(),
                            child: Container(                      
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 34,
                                    width: 34,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Center(
                                      child: Image.asset("assets/images/google_logo.png", height: 30, width: 30,),
                                    ),
                                  ),
                                  Text("Login With Google", style: TextStyle(color: Colors.white, fontSize: 18),),
                                  Container(
                                    height: 40,
                                    width: 34,
                                  )
                                ],
                              ), 
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
      ),
    );
  }
}