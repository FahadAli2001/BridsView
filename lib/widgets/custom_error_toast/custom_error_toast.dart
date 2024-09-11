import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomErrorToast({
  required String message,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red.shade800,
    textColor: Colors.white,
    fontSize: 16,
  );
}
