import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Login.dart';
import 'package:flutter_app/Views/Products.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'APK Ciper',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Login(),
        routes: <String, WidgetBuilder>{
          '/login_page': (BuildContext context) => Login(),
          '/product_list': (BuildContext context) => Products(),
          '/product_detail': (BuildContext context) =>
              ModalRoute.of(context).settings.arguments,
        });
  }
}
