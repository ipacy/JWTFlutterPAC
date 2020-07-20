import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasted {
  static Future<void> showToast(messageText, size) {
    Fluttertoast.showToast(
        msg: messageText,
        toastLength:
            (size == 'short') ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG);
  }

  static showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
