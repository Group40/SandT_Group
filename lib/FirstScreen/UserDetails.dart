/*import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

String _token;
String _id;
String _fname;
String _lname;
String _email;

Future<bool> _tryAutoLogin() async {
  await Future.delayed(Duration(milliseconds: 3000));
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('userData')) {
    return false;
  }
  final extractedUserData =
      json.decode(prefs.getString('userData')) as Map<String, Object>;

  _token = extractedUserData['token'];
  _fname = extractedUserData['username'];
  _lname = extractedUserData['lname'];
  _email = extractedUserData['email'];

  return true;
}

String getUsername() {
  String username = _fname + _lname;
  return username;
}

String getEmail() {
  return _email;
}

String getToken() {
  return _token;
}
*/