import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'validators.dart';

class Bloc with Validators {
  final _registerEmailController = BehaviorSubject<String>();
  final _registerPasswordController = BehaviorSubject<String>();

  final _loginEmailController = BehaviorSubject<String>();
  final _loginPasswordController = BehaviorSubject<String>();

  Stream<String> get email => _registerEmailController.stream.transform<String>(validateEmail);
  Stream<String> get password => _registerPasswordController.stream.transform<String>(validatePassword);
  Stream<bool> get registerSubmit => Rx.combineLatest2(email, password, (a, b) => true);

  Stream<String> get loginEmail => _loginEmailController.stream.transform<String>(validateLoginField);
  Stream<String> get loginPassword => _loginPasswordController.stream.transform<String>(validateLoginField);
  Stream<bool> get loginSubmit => Rx.combineLatest2(loginEmail, loginPassword, (a, b) => true);

  Function(String) get changeEmail => _registerEmailController.sink.add;
  Function(String) get changePassword => _registerPasswordController.sink.add;

  Function(String) get changeLoginEmail => _loginEmailController.sink.add;
  Function(String) get changeLoginPassword => _loginPasswordController.sink.add;

  register() {
    final validEmail = _registerEmailController.value;
    final validPassword = _registerPasswordController.value;

    return <String, String>{
      "email": validEmail,
      "password": validPassword
    };
  }

  login() {
    final validEmail = _loginEmailController.value;
    final validPassword = _loginPasswordController.value;

    print("Validado");
  }

  dispose() {
    _registerEmailController.close();
    _registerPasswordController.close();

    _loginEmailController.close();
    _loginPasswordController.close();
  }
}