import 'package:app/src/blocs/bloc_base.dart';

import 'package:rxdart/rxdart.dart';

class LoginBloc implements BlocBase {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  
  @override
  dispose() async {
    await this._emailController.drain();
    this._emailController.close();
    await this._passwordController.drain();
    this._passwordController.close();
  }
}