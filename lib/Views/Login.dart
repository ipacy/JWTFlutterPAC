import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/Controllers/LoginController.dart';
import 'package:flutter_app/Models/Response/Result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Toasted.dart';

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

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (oContext) => Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              Text(
                'Vistex Products',
                style:
                    new TextStyle(fontWeight: FontWeight.w500, fontSize: 40.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.0),
              emailC,
              SizedBox(height: 8.0),
              passwordC,
              SizedBox(height: 24.0),
              CupertinoButton(
                child: Text('Login'),
                color: Color.fromARGB(150, 0, 0, 255),
                onPressed: () async {
                  LoginController loginController = new LoginController();
                  Map userDetail = {
                    'username': _textController.text,
                    'password': _passController.text
                  };
                  final storage = new FlutterSecureStorage();

                  var oProceed = await loginController.loginUser(userDetail);
                  try {
                    if (oProceed is SuccessState) {
                      var body = json.decode(oProceed.value);
                      if (body['token'] != null) {
                        storage.write(key: "token", value: body['token']);
                        storage.write(
                            key: "expireDate", value: body['expireDate']);
                        Navigator.pushNamed(context, '/product_list');
                      } else {
                        Toasted.showSnackBar(oContext, body['message']);
                      }
                    } else {
                      Toasted.showSnackBar(oContext, 'Login Failed');
                    }
                  } catch (e) {
                    Toasted.showSnackBar(oContext, 'Login Failed');
                  }
                },
              ),
              forgotLabel
            ],
          ),
        ),
      ),
    );
  }
}
