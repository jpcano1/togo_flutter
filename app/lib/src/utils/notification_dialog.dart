import 'package:flutter/material.dart';

dialog(context, String message, {onPressed}) {
  showDialog(
    context: context, 
    builder: (dialogContext) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                message,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Colors.black
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextButton(
                  onPressed: onPressed != null? onPressed: 
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