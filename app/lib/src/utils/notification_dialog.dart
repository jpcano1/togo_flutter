import 'package:flutter/material.dart';
import 'night_mode.dart';

dialog(context, {String message, Function onPressed, Widget content}) {
  bool nightMode = isNightMode();
  showDialog(
    context: context, 
    builder: (dialogContext) {
      return AlertDialog(
        content: content?? SingleChildScrollView(
          child: Column(
            children: [
              Text(
                message?? "",
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: nightMode? Colors.white: Colors.black
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextButton(
                  onPressed: onPressed?? 
                    () => Navigator.pop(dialogContext),
                  child: Text("Ok"),
                )
              ),
            ],
          ),
        ),
      );
    }
  );
}