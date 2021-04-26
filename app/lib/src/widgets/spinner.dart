import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {

  final Color backgroundColor;
  final Color color;

  LoadingSpinner({this.backgroundColor, this.color});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 0.2,
      width: size.width * 0.2,
      color: Colors.transparent,
      child: SpinKitChasingDots(
        color: this.color?? Theme.of(context).colorScheme.primary,
        size: 50.0,
      )
    );
  }
}
