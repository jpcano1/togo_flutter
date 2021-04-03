import 'dart:async';

import 'validators.dart';
import 'bloc_base.dart';
import '../../resources/repository.dart';

import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators implements BlocBase {
  final _repository = Repository();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get loginEmail => _emailController.stream.transform<String>(validateEmptyField);
  Stream<String> get loginPassword => _passwordController.stream.transform<String>(validateEmptyField);
  Stream<bool> get loginSubmit => Rx.combineLatest2(
    loginEmail,
    loginPassword,
    (a, b) => true
  );

  Function(String) get changeLoginEmail => _emailController.sink.add;
  Function(String) get changeLoginPassword => _passwordController.sink.add;

  Future<Map<String, dynamic>> login() async {
    FirebaseAuth.UserCredential credential;
    try{
      credential= await _repository.login(
        email: this._emailController.value, 
        password: this._passwordController.value
      );
    } on FirebaseAuth.FirebaseException catch(e) {
      return Future.error("Wrong email or password");
    }
    
    return {
      "verified": credential.user.emailVerified,
      "document": await _repository.readUser(uid: credential.user.uid)
    };
  }

  @override
  dispose() async {
    await this._emailController.drain();
    this._emailController.close();
    await this._passwordController.drain();
    this._passwordController.close();
  }
}