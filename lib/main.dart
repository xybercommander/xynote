import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xynote/data/providers/user_provider.dart';
import 'package:xynote/views/splash_screen.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(),)
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',   
      theme: ThemeData(        
        primarySwatch: Colors.blue,
        fontFamily: 'RobotoSlabMedium'
      ),
      home: SplashScreen(),
    );
  }
}