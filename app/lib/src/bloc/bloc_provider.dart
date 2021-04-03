import 'blocs/bloc_base.dart';
import 'package:flutter/material.dart';

class Provider<T extends BlocBase> extends InheritedWidget {
  final T bloc;
  final Widget child;

  Provider({
    Key key,
    @required this.bloc,
    @required this.child
  }): super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static T of<T extends BlocBase>(BuildContext context) {
    Provider<T> provider = context.dependOnInheritedWidgetOfExactType<Provider<T>>();
    return provider.bloc;
  }
}