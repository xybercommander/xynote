import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:xynote/data/helper/shared_preferences.dart';
import 'package:xynote/data/providers/user_provider.dart';
import 'package:xynote/views/auth/sign_in_page.dart';
import 'package:xynote/views/auth/sign_up_page.dart';
import 'package:xynote/views/accounts_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void loadDataAndNavigate() async {
    bool? loggedInState = await SharedPref.getLoggedInSharedPreference();
    String? email = await SharedPref.getEmailSharedPreference();
    String? username = await SharedPref.getUsernameSharedPreference();
    String? imgUrl = await SharedPref.getImgUrlSharedPreference();

    Future.delayed(Duration(seconds: 3), () => {
      if(loggedInState == false || loggedInState == null) {
        Navigator.pushReplacement(context, PageTransition(child: SignInPage(), type: PageTransitionType.rightToLeft))
      } else {
        Provider.of<UserProvider>(context, listen: false).setEmail(email!),
        Provider.of<UserProvider>(context, listen: false).setUsername(username!),
        Provider.of<UserProvider>(context, listen: false).setImageUrl(imgUrl!),
        Navigator.pushReplacement(context, PageTransition(child: AccountsPage(), type: PageTransitionType.rightToLeft))
      }       
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