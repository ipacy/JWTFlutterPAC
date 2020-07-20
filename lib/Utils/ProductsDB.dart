import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/Product.dart';
import 'package:flutter_app/Models/Result.dart';
import 'package:flutter_app/Utils/DBManager.dart';
import 'package:http/http.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProductsDB {
  //Creating Singleton
  ProductsDB._privateConstructor();

  static final ProductsDB _apiResponse = ProductsDB._privateConstructor();

  factory ProductsDB() => _apiResponse;

  final _storage = FlutterSecureStorage();
  StreamController<Result> _addBookStream;

  Future<String> get jwtOrEmpty async {
    var storage = new FlutterSecureStorage();
    var jwt = await storage.read(key: "token");
    if (jwt == null) return "";
    return jwt;
  }

  Future<Result> getBooks() async {
    var oToken = await jwtOrEmpty;
    try {
      final response = await DBManager.getProducts(oToken, '/api/products');
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body)['data'];
        var fList = list.map((model) {
          return Product.fromJson(model);
        }).toList();
        return Result<List<Product>>.success(fList);
      } else {
        return Result.error("Book list not available");
      }
    } catch (error) {
      return Result.error("Something went wrong!");
    }
  }
}
