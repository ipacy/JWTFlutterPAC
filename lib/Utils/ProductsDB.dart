import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/Models/Product.dart';
import 'package:flutter_app/Models/Result.dart';
import 'package:flutter_app/Utils/DBManager.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProductsDB {
  //Creating Singleton
  ProductsDB._privateConstructor();

  static final ProductsDB _apiResponse = ProductsDB._privateConstructor();

  factory ProductsDB() => _apiResponse;

  final _storage = FlutterSecureStorage();
  // StreamController<Result> _addBookStream;

  Future<String> get jwtOrEmpty async {
    var storage = new FlutterSecureStorage();
    var jwt = await storage.read(key: "token");
    if (jwt == null) return "";
    return jwt;
  }

  Future<Result> getProducts() async {
    var oToken = await jwtOrEmpty;
    try {
      final response = await DBManager.getItems(oToken, '/api/products');
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body)['data'];
        var fList = list.map((model) {
          return Product.fromJson(model);
        }).toList();
        return Result<List<Product>>.success(fList);
      } else {
        return Result.error("Product list not available");
      }
    } catch (error) {
      return Result.error("Something went wrong!");
    }
  }

  Future<Result> deleteProduct(String sId) async {
    var oToken = await jwtOrEmpty;
    try {
      final response = await DBManager.deleteItem(oToken, '/api/products', sId);
      if (response.statusCode == 200) {
        return Result<String>.success(
            json.decode(response.body)['message']['text']);
      } else {
        return Result.error("Product cannot be deleted");
      }
    } catch (error) {
      return Result.error("Something went wrong!");
    }
  }

  Future<Result> addProduct(dynamic product) async {
    var oToken = await jwtOrEmpty;
    try {
      final response = await DBManager.addItem(
          oToken, '/api/products/', json.encode(product));
      if (response.statusCode == 200) {
        return Result<String>.success(
            json.decode(response.body)['message']['text']);
      } else {
        return Result.error("Product cannot be deleted");
      }
    } catch (error) {
      return Result.error("Something went wrong!");
    }
  }

  Future<Result> updateProduct(dynamic product, String sId) async {
    var oToken = await jwtOrEmpty;
    try {
      final response = await DBManager.updateItem(
          oToken, '/api/products/' + sId, json.encode(product));
      if (response.statusCode == 200) {
        return Result<String>.success(
            json.decode(response.body)['message']['text']);
      } else {
        return Result.error("Product cannot be deleted");
      }
    } catch (error) {
      return Result.error("Something went wrong!");
    }
  }
}
