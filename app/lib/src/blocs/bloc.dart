import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'validators.dart';

class Bloc with Validators {
  final _registerEmailController = BehaviorSubject<String>();
  final _registerPasswordController = BehaviorSubject<String>();
  final _registerNameController = BehaviorSubject<String>();

  final _loginEmailController = BehaviorSubject<String>();
  final _loginPasswordController = BehaviorSubject<String>();

  Stream<String> get registerEmail => _registerEmailController.stream.transform<String>(validateEmail);
  Stream<String> get registerPassword => _registerPasswordController.stream.transform<String>(validatePassword);
  Stream<String> get registerName => _registerNameController.stream.transform<String>(validateEmptyField);
  Stream<bool> get registerSubmit => Rx.combineLatest3(
    registerEmail,
    registerPassword,
    registerName,
    (a, b, c) => true
  );

  Stream<String> get loginEmail => _loginEmailController.stream.transform<String>(validateEmptyField);
  Stream<String> get loginPassword => _loginPasswordController.stream.transform<String>(validateEmptyField);
  Stream<bool> get loginSubmit => Rx.combineLatest2(
    loginEmail,
    loginPassword,
    (a, b) => true
  );

  Function(String) get changeRegisterEmail => _registerEmailController.sink.add;
  Function(String) get changeRegisterPassword => _registerPasswordController.sink.add;
  Function(String) get changeRegisterName => _registerNameController.sink.add;

  Function(String) get changeLoginEmail => _loginEmailController.sink.add;
  Function(String) get changeLoginPassword => _loginPasswordController.sink.add;

  register() {
    final validEmail = _registerEmailController.value;
    final validPassword = _registerPasswordController.value;
    final validName = _registerNameController.value;

    return <String, String> {
      "email": validEmail,
      "password": validPassword,
      "name": validName
    };
  }

  login() {
    final validEmail = _loginEmailController.value;
    final validPassword = _loginPasswordController.value;

    return <String, String> {
      "email": validEmail,
      "password": validPassword
    };
  }

  dispose() {
    _registerEmailController.close();
    _registerPasswordController.close();

    _loginEmailController.close();
    _loginPasswordController.close();
  }
}