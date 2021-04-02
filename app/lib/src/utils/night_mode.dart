import 'package:flutter/material.dart';

bool isNightMode() {
  bool nightMode;
  var now = TimeOfDay.now();
  if (now.hour > 18 || now.hour < 6) {
    nightMode = true;
  } else {
    nightMode = false;
  }
  return nightMode;
}