import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _username = "";
  String _email = "";
  String _imageUrl = "";

  String get username => _username;
  String get email => _email;
  String get imageUrl => _imageUrl;
}