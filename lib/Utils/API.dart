import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//const baseUrl = "https://jsonplaceholder.typicode.com";

class API {
  static Future getProducts() {
    var oToken = jwtOrEmpty as String;
    var url = 'http://10.0.2.2:8000/api/products';
    return http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + oToken,
    });
  }

  static Future<String> get jwtOrEmpty async {
    var storage = new FlutterSecureStorage();
    var jwt = await storage.read(key: "token");
    if (jwt == null) return "";
    // setState(() {
    //   this.token = jwt;
    // });
    return jwt;
  }
}
