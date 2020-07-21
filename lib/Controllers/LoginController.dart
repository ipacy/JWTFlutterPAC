import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/Enums/request_type.dart';
import 'package:flutter_app/Models/DBManager/DBManager.dart';
import 'package:flutter_app/Models/Response/Result.dart';

class LoginController {
  LoginController._privateConstructor();

  static final LoginController _apiResponse =
      LoginController._privateConstructor();

  factory LoginController() => _apiResponse;

  Future<Result> loginUser(dynamic userDetails) async {
    try {
      final response = await DBManager.callDB(
          RequestType.POST, '/api/Auth/login', '', json.encode(userDetails));
      if (response.statusCode == 200) {
        return Result<String>.success(response.body);
      } else {
        return Result.error("Login Error");
      }
    } catch (error) {
      return Result.error("Something is wrong");
    }
  }
}
