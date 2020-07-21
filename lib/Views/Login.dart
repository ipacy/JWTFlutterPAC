import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/Utils/Toasted.dart';

// import 'package:login/home_page.dart';
final storage = new FlutterSecureStorage();

class Login extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<Login> {
  TextEditingController _textController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo2.png'),
      ),
    );
    _textController.text = 'abhi@email.com';
    final emailC = CupertinoTextField(
      controller: _textController,
      autofocus: false,
      placeholder: 'Email',
    );

    _passController.text = 'Test@123';
    final passwordC = CupertinoTextField(
      controller: _passController,
      autofocus: false,
      obscureText: true,
      placeholder: 'Password',
    );

    final loginC = CupertinoButton(
      child: Text('Login'),
      color: Color.fromARGB(150, 0, 0, 255),
      onPressed: () async {
        var proceed = await loginUser('abhi@email.com', 'Test@123');
        if (proceed) {
          Toasted.showToast('Logged in Successfully', 'long');
          Navigator.pushNamed(context, '/product_list');
        } else {
          Toasted.showSnackBar(context, 'Login Failed');
        }
      },
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            Text(
              'Vistex Products',
              style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 40.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48.0),
            emailC,
            SizedBox(height: 8.0),
            passwordC,
            SizedBox(height: 24.0),
            loginC,
            forgotLabel
          ],
        ),
      ),
    );
  }

  Future<bool> loginUser(String username, String password) async {
    // var oUrl1 = 'http://localhost:8000/api/Auth/login';
    var oUrl2 = 'http://10.0.2.2:8000/api/Auth/login';
    final http.Response response = await http.post(
      oUrl2,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _textController.text,
        'password': _passController.text,
      }),
    );
    if (response.statusCode == 200) {
      //return LoginUser.fromJson(json.decode(response.body));
      var body = json.decode(response.body);
      storage.write(key: "token", value: body['token']);
      storage.write(key: "expireDate", value: body['expireDate']);
      return true;
    } else {
      return false;
      // throw Exception('Failed to load album');
    }
  }
}
