import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/Enums/request_type.dart';
import 'package:flutter_app/Models/Product.dart';
import 'package:flutter_app/Models/Response/Result.dart';
import 'package:flutter_app/Models/DBManager/DBManager.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProductsController {
  //Creating Singleton
  ProductsController._privateConstructor();

  static final ProductsController _apiResponse =
      ProductsController._privateConstructor();

  factory ProductsController() => _apiResponse;

  StreamController<Result> _addProductStream;
  Stream<Result> hasBookAdded() => _addProductStream.stream;
  void init() => _addProductStream = StreamController();

  Future<Result> getProducts() async {
    //_addProductStream.sink.add(Result<String>.loading("Loading"));

    try {
      final response = await DBManager.callDB(RequestType.GET, '/api/products');
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body)['data'];
        var fList = list.map((model) {
          return Product.fromJson(model);
        }).toList();
        //_addProductStream.sink.add(Result.error("Product list not available"));
        return Result<List<Product>>.success(fList);
      } else {
        // _addProductStream.sink.add(Result.error("Product list not available"));
        return Result.error("Product list not available");
      }
    } catch (error) {
      // _addProductStream.sink.add(Result.error("Something went wrong!"));
      return Result.error("Something went wrong!");
    }
  }

  Future<Result> deleteProduct(String sId) async {
    //  _addProductStream.sink.add(Result<String>.loading("Loading"));

    try {
      final response =
          await DBManager.callDB(RequestType.DELETE, '/api/products/' + sId);
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
    // _addProductStream.sink.add(Result<String>.loading("Loading"));

    try {
      final response = await DBManager.callDB(
          RequestType.POST, '/api/products/', '', json.encode(product));
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
    // _addProductStream.sink.add(Result<String>.loading("Loading"));
    try {
      final response = await DBManager.callDB(
          RequestType.PUT, '/api/products/' + sId, '', json.encode(product));
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

  void dispose() => _addProductStream.close();
}
