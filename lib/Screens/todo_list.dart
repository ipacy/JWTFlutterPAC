import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/Product.dart';
import 'package:flutter_app/Models/Result.dart';
import 'package:flutter_app/Utils/DBManager.dart';
import 'package:flutter_app/Utils/ProductsDB.dart';
import 'package:flutter_app/Utils/Toasted.dart';
import 'package:flutter_app/Utils/database_helper.dart';
import 'package:flutter_app/Screens/todo_detail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_guid/flutter_guid.dart';

final storage = new FlutterSecureStorage();

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Product> productList;
  int count = 0;
  String token;

  @override
  Widget build(BuildContext context) {
    if (productList == null) {
      productList = List<Product>();
      getProduct();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('APK Cipher'),
        backgroundColor: Colors.blueGrey,
      ),
      body: getTodoListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Product(new Guid(''), '', '', 0), 'Add Todo');
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: this.productList.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.productList[index].name),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.productList[index].name,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.productList[index].price.toString() +
                this.productList[index].unit),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    _delete(context, this.productList[index]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              // Navigator.pushNamed(context, '/todo_detail');
              navigateToDetail(this.productList[index], 'Product Details');
            },
          ),
        );
      },
    );
  }

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "token");
    if (jwt == null) return "";
    return jwt;
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Product product) async {
    var oToken = await jwtOrEmpty;

    http.delete(
      'http://10.0.2.2:8000/api/products/' + product.id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + oToken,
      },
    ).then((response) {
      var oMessage = json.decode(response.body)['message']['text'];
      Toasted.showSnackBar(context, oMessage);
      this.getProduct();
    });
  }

  void navigateToDetail(Product product, String title) async {
    await Navigator.pushNamed(context, '/product_detail',
        arguments: TodoDetail(
          product,
          title,
        ));
  }

  void getProduct() async {
    ProductsDB productsDb = new ProductsDB();
    var oList = await productsDb.getBooks() as SuccessState;

    setState(() {
      productList = oList.value;
    });
    /*    var oToken = await jwtOrEmpty;
 http.get(
      'http://10.0.2.2:8000/api/products',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + oToken,
      },
    ).then((response) {
      setState(() {
        Iterable list = json.decode(response.body)['data'];
        var fList = list.map((model) {
          return Product.fromJson(model);
        }).toList();
        productList =
            fList; //list.map((model) => Product.fromJson(model)).toList();
      });
    }); */
  }
}
