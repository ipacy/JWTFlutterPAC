import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/Enums/request_type.dart';
import 'package:flutter_app/Models/Product.dart';
import 'package:flutter_app/Models/Response/Result.dart';
import 'package:flutter_app/Models/DBManager/DBManager.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginController {
  //Creating Singleton
  LoginController._privateConstructor();

  static final LoginController _apiResponse =
      LoginController._privateConstructor();

  factory LoginController() => _apiResponse;
  final storage = new FlutterSecureStorage();
  Future<bool> loginUser(dynamic userDetails) async {
    try {
      final response = await DBManager.callDB(
          RequestType.POST, '/api/Auth/login', '', json.encode(userDetails));

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        storage.write(key: "token", value: body['token']);
        storage.write(key: "expireDate", value: body['expireDate']);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
