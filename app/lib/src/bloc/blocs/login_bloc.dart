import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../resources/repository.dart';
import 'bloc_base.dart';
import 'validators.dart';

class LoginBloc with Validators implements BlocBase {
  final _repository = Repository();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get loginEmail =>
      _emailController.stream.transform<String>(validateEmptyField);
  Stream<String> get loginPassword =>
      _passwordController.stream.transform<String>(validateEmptyField);
  Stream<bool> get loginSubmit =>
      Rx.combineLatest2(loginEmail, loginPassword, (a, b) => true);

  Function(String) get changeLoginEmail => _emailController.sink.add;
  Function(String) get changeLoginPassword => _passwordController.sink.add;

  //Method to log in with internet connection. Returns a map
  //with the verification status of the user and the model of the user logged.
  Future<Map<String, dynamic>> login() async {
    //TODO adjust sharedPreferences to singleton
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseAuth.UserCredential credential;
    try {
      credential = await _repository.login(
          email: this._emailController.value,
          password: this._passwordController.value);
    } on FirebaseAuth.FirebaseException catch (_) {
      return Future.error("Wrong email or password");
    }

    //Save locally the last successful online session credentials
    await prefs.setString("logEmail", this._emailController.value);
    await prefs.setString("logPassword", this._passwordController.value);

    //Indicates locally that the user was not offline at the moment of this
    //action
    await prefs.setBool("was_offline", false);

    String name = this._repository.getCurrentUser().displayName;

    await prefs.setString("logName", name);
    return {
      "verified": credential.user.emailVerified,
      "document": await _repository.readUser(uid: credential.user.uid)
    };
  }

  //Method to check locally saved credentials to log in without connection.
  Future<String> offlineLogin() async {
    //TODO adjust sharedPreferences to singleton
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastSesEmail = prefs.getString("logEmail");
    String lastSesPassword = prefs.getString("logPassword");
    String result = "invalid";

    if (lastSesEmail != null && lastSesPassword != null) {
      //Indicates locally that the user is offline at the moment of this
      //action

      String currentEmail = this._emailController.value;
      String currentPassword = this._passwordController.value;

      if (lastSesEmail == currentEmail && lastSesPassword == currentPassword) {
        result = "valid";
      }
    }
    await prefs.setBool("was_offline", false);
    return result;
  }

  @override
  dispose() async {
    await this._emailController.drain();
    this._emailController.close();
    await this._passwordController.drain();
    this._passwordController.close();
  }
}
