import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Color color;
  final String text;
  final Function onPressed;
  final double minWidth;
  final Widget child;

  AppButton({@required this.color, this.text, @required this.onPressed, this.minWidth, this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: this.child ?? Text(
        this.text?? "",
        style: Theme.of(context).textTheme.button,
      ),
      color: this.color,
      onPressed: this.onPressed,
      minWidth: minWidth,
      disabledColor: Theme.of(context).disabledColor,
    );
  }
}