import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class SignUpl{
  String username;
  String email;
  String password;

SignUpl(
  {
    @required this.password,
    @required this.email,
    @required this.username,
  }
);

 
  Map<String, dynamic> toJson() {
    return{
    "username": username,
    "email" : email,
    "password" : password,
    "roles": "user"
  };
}
}