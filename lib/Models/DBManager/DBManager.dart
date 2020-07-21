import 'dart:async';
import 'package:flutter_app/Enums/request_type.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:8000";

class DBManager {
  static Future callDB(RequestType requestType, String thoken, path,
      [String sId, dynamic parameter]) async {
    final _storage = FlutterSecureStorage();
    final oToken = await _storage.read(key: 'token');
    switch (requestType) {
      case RequestType.GET:
        return http.get(baseUrl + path, headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + oToken,
        });
        break;
      case RequestType.POST:
        return http.post(baseUrl + path,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ' + oToken,
            },
            body: parameter);
        break;
      case RequestType.DELETE:
        return http.delete(baseUrl + path, headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + oToken,
        });
        break;
      case RequestType.PUT:
        return http.put(baseUrl + path,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ' + oToken,
            },
            body: parameter);
        break;
    }
  }
}
