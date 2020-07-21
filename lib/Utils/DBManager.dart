import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:8000";

class DBManager {
  static Future getItems(String oToken, path) {
    var url = baseUrl + path;
    return http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + oToken,
    });
  }

  static Future deleteItem(String oToken, path, sId) {
    var url = baseUrl + path + '/' + sId;
    return http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + oToken,
    });
  }

  static Future addItem(String oToken, path, dynamic parameter) {
    return http.post(baseUrl + path,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + oToken,
        },
        body: parameter);
  }

  static Future updateItem(String oToken, path, dynamic parameter) {
    return http.put(baseUrl + path,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + oToken,
        },
        body: parameter);
  }
}
