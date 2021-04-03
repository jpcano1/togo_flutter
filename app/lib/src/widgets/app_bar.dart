import 'package:flutter/material.dart';

AppBar appBar({@required Color backgroundColor, 
               @required Color iconColor}) {
  return AppBar(
    backgroundColor: backgroundColor,
    elevation: 0.0,
    iconTheme: IconThemeData(
      color: iconColor
    ),
  );
}