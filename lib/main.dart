import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/todo_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Screens/LoginPage.dart';

// import 'package:todo_list/Screens/todo_detail.dart';
final storage = new FlutterSecureStorage();

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'APK Ciper',
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(primarySwatch: Colors.blue),
  //     home: TodoList(),
  //   );
  // }
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'APK Ciper',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
        routes: <String, WidgetBuilder>{
          '/login_page': (BuildContext context) => LoginPage(),
          '/todo_list': (BuildContext context) => ProductList(),
          '/product_detail': (BuildContext context) =>
              ModalRoute.of(context).settings.arguments,
        });
  }
}
