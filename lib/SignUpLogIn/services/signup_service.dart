/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

var url = "http://10.0.2.2:8080/auth/signin";

class Auth with ChangeNotifier {
  String username;
  String lname;
  String email;
  String token;

  Future<void> sendlog(String email, String password) async {
    var body = jsonEncode({
      'email': email,
      'password': password
    });
    final res = await http.post(url, body: body);
    print(res);
  }
}*/
