import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  //----- GOOGLE SIGN IN -----//
  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
    // return googleUser!.email.toString();
  }

  //------- SIGN OUT -------//
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}