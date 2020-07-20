import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const baseUrl = "http://10.0.2.2:8000";

class DBManager {
  static Future getProducts(String oToken, path) {
    var url = baseUrl + path;
    return http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + oToken,
    });
  }
}
