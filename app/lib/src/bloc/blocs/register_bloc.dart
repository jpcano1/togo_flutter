import 'dart:async';

import 'validators.dart';
import 'bloc_base.dart';
import '../../resources/repository.dart';
import '../../models/user.dart' as UserModel;

import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:rxdart/rxdart.dart';

class RegisterBloc with Validators implements BlocBase {
  final _repository = Repository();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();

  Stream<String> get registerEmail => _emailController.stream.transform<String>(validateEmail);
  Stream<String> get registerPassword => _passwordController.stream.transform<String>(validatePassword);
  Stream<String> get registerName => _nameController.stream.transform<String>(validateEmptyField);
  Stream<String> get registerPhone => _phoneController.stream.transform(validateEmptyField);
  Stream<bool> get registerSubmit => Rx.combineLatest4(
    registerEmail,
    registerPassword,
    registerName,
    registerPhone,
    (email, password, name, phone) => true
  );

  Function(String) get changeRegisterEmail => _emailController.sink.add;
  Function(String) get changeRegisterPassword => _passwordController.sink.add;
  Function(String) get changeRegisterName => _nameController.sink.add;
  Function(String) get changeRegisterPhone => _phoneController.sink.add;

  Future<UserModel.User> register(String zone) async {
    FirebaseAuth.UserCredential credentials;
    UserModel.User currentUser;
    try {
      credentials = await _repository.register(
        email: _emailController.value,
        password: _passwordController.value
      );

      await _repository.updateUserData(
        data: {
          "displayName": _nameController.value
        }
      );

      currentUser = UserModel.User(
        credentials.user.uid,
        _nameController.value, _emailController.value,
        phoneNumber: zone + _phoneController.value
      );

      await _repository.createUser(currentUser: currentUser);
      await credentials.user.sendEmailVerification();

    } on FirebaseAuth.FirebaseException catch(e) {
      var message = "";
      if (e.code == "weak-password") {
        message = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        message = "The account already exists for that email.";
      } else if (e.code == "permission-denied") {
        message = "You do not have permission to perform this.";
      }
      return Future.error(message);
    } catch(e) {
      print(e.toString());
    }

    return currentUser;
  }

  @override
  dispose() async {
    await this._emailController.drain();
    this._emailController.close();
    await this._passwordController.drain();
    this._passwordController.close();
    await this._nameController.drain();
    this._nameController.close();
    await this._phoneController.drain();
    this._phoneController.close();
  }
}