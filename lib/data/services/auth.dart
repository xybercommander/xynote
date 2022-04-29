import 'package:firebase_auth/firebase_auth.dart';
import 'package:xynote/data/models/user_profile_model.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserProfile? _userFromFirebaseUser(User user) {    
    return UserProfile(userId: user.uid);
  }

  //--------- SIGN UP ---------//  
  Future<UserProfile?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
    }
    return null;
  }

   //--------- SIGN IN ---------//
  Future<UserProfile?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
    }
    return null;
  }
}