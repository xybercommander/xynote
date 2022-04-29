import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  //-------- UPLOAD USER INFO --------//
  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  //-------- GET THE USER DATA --------//
  Future<Stream<QuerySnapshot>> getUserInfoByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: userEmail)
      .snapshots();
  }
  
}