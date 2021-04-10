import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(msg, context) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    textColor: Colors.white,
    backgroundColor: Theme.of(context).colorScheme.primary
  );
}