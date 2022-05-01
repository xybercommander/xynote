import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  static String loggedInSharedPreferenceKey = "LOGGEDINKEY";
  static String emailSharedPreferenceKey = "EMAILKEY";
  static String usernameSharedPreferenceKey = "USERNAMEKEY";
  static String imgUrlSharedPreferenceKey = "IMGURLKEY";

  //-------- SET FUNCTION --------//
  static Future<bool> saveLoggedInSharedPreference(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(loggedInSharedPreferenceKey, isUserLoggedIn);
  }

  static Future<bool> saveEmailSharedPreference(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(emailSharedPreferenceKey, email);
  }

  static Future<bool> saveUsernameSharedPreference(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(usernameSharedPreferenceKey, username);
  }

  static Future<bool> saveImgUrlSharedPreference(String imgUrl) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(imgUrlSharedPreferenceKey, imgUrl);
  }

  //-------- GET FUNCTION --------//
  static Future<bool?> getLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(loggedInSharedPreferenceKey);
  }
  
  static Future<String?> getEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(emailSharedPreferenceKey);
  }
  
  static Future<String?> getUsernameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(usernameSharedPreferenceKey);
  }

  static Future<String?> getImgUrlSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(imgUrlSharedPreferenceKey);
  }

}