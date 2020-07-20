import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecHelper {
  static SecHelper _databaseHelper; // Singleton DatabaseHelper
  static FlutterSecureStorage _secureStorage; // Singleton Database
  //storage = new FlutterSecureStorage();

  SecHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory SecHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = SecHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<FlutterSecureStorage> get secureStorage async {
    if (_secureStorage == null) {
      _secureStorage = FlutterSecureStorage();
    }
    return _secureStorage;
  }

  Future<void> insertToken(String jwttoken) async {
    FlutterSecureStorage db = await this.secureStorage;
    db.write(key: "jwt", value: jwttoken);
  }

  Future<void> insertTime(String time) async {
    FlutterSecureStorage db = await this.secureStorage;
    db.write(key: "time", value: time);
  }

  Future<String> jwtOrEmpty(String oKey) async {
    FlutterSecureStorage db = await this.secureStorage;
    var secKey = await db.read(key: oKey);
    if (secKey == null) return "";
    return secKey;
  }
}
