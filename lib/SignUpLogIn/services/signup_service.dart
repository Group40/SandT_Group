import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/SignUp.dart';
import '../model/response.dart';

class Signupservice {
  static const API = 'http://localhost:8080/api/auth';
  static const headers = {
    //'apiKey': '08d771e2-7c49-1789-0eaa-32aff09f1471',
    'Content-Type': 'application/json'
  };

  static Future<APIResponse<bool>> createacc(SignUpl item) {
    return http
        .post(API + '/signup', body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }
}
