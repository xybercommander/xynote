import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:xynote/views/auth/sign_in_page.dart';
import 'package:xynote/views/auth/sign_up_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void loadDataAndNavigate() {
    Future.delayed(Duration(seconds: 3), () => {
      Navigator.pushReplacement(context, PageTransition(child: SignInPage(), type: PageTransitionType.rightToLeft))
    });
  }

  @override
  void initState() {    
    super.initState();
    loadDataAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/animations/loading.json"),
          SizedBox(height: 16,),
          Text('Loading', style: TextStyle(fontSize: 24),)
        ],
      ),
    );
  }
}