import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart' as UserModel;
import '../../resources/repository.dart';
import 'bloc_base.dart';
import 'validators.dart';

class RegisterBloc with Validators implements BlocBase {
  final _repository = Repository();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();

  //TODO Comment controllers
  var textNameController = TextEditingController();
  var textEmailController = TextEditingController();
  var textPhoneController = TextEditingController();

  Stream<String> get registerEmail =>
      _emailController.stream.transform<String>(validateEmail);
  Stream<String> get registerPassword =>
      _passwordController.stream.transform<String>(validatePassword);
  Stream<String> get registerName =>
      _nameController.stream.transform<String>(validateEmptyField);
  Stream<String> get registerPhone =>
      _phoneController.stream.transform(validateEmptyField);
  Stream<bool> get registerSubmit => Rx.combineLatest4(
      registerEmail,
      registerPassword,
      registerName,
      registerPhone,
      (email, password, name, phone) => true);

  Function(String) get changeRegisterEmail => _emailController.sink.add;
  Function(String) get changeRegisterPassword => _passwordController.sink.add;
  Function(String) get changeRegisterName => _nameController.sink.add;
  Function(String) get changeRegisterPhone => _phoneController.sink.add;

  //Initialize credentials from sharedPreferences
  //TODO Erase commented code, erase print()
  RegisterBloc() {
    print("Entró al contructor");
    // getName();
    noConnectionLoadCredentials();

    print("Valor actual textEditingController: " + textNameController.text);
  }
  //TODO Erase commented code
  // //Method to get the name saved in the controller
  // getName() {
  //   print("Entró a get name método");
  //   var name = _nameController.value;
  //   if (name != null) {
  //     print("Entró a get name no nulo: " + _nameController.value);
  //     textNameController.text = _nameController.value;
  //   } else {
  //     print("Entró a get name null");
  //     textNameController.text = "";
  //   }
  // }
  //
  // getEmail<String>() {
  //   var email = _emailController.value;
  //   if (email != null) {
  //     return _emailController.value;
  //   } else {
  //     return "";
  //   }
  // }
  //
  // getPhone<String>() {
  //   var email = _phoneController.value;
  //   if (email != null) {
  //     return _phoneController.value;
  //   } else {
  //     return "";
  //   }
  // }

  //Method to save credentials inside shared preferences when there's no
  //connection.
  //Password not saved
  noConnectionSaveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //If the email is not empty save the email in shared preferences
    //else save empty string.
    if (_emailController.value != null) {
      await prefs.setString('regEmail', _emailController.value);
    } else {
      await prefs.setString('regEmail', "");
    }
    //If the name is not empty save the name in shared preferences
    //else save empty string.
    if (_nameController.value != null) {
      await prefs.setString('regName', _nameController.value);
    } else {
      await prefs.setString('regName', "");
    }

    //If the phone number is not empty save the phone number in shared preferences
    //else save empty string.
    if (_nameController.value != null) {
      await prefs.setString('regPhone', _phoneController.value);
    } else {
      await prefs.setString('regPhone', "");
    }

    await prefs.setBool("was_offline", true);
  }

  //Method to load credentials from shared preferences when there's connection.
  noConnectionLoadCredentials() async {
    //TODO check singleton get instance for bloc
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('regName');
    String email = prefs.getString('regEmail');
    String phone = prefs.getString('regPhone');
    bool wasOffline = prefs.getBool('was_offline');

    //TODO Erase  prints after checking functionality
    print("Estaba sin internet: " + wasOffline.toString());
    print("Nombre extraido: " + name);
    if (wasOffline != null && wasOffline == true) {
      print("Está en el caso en que estaba sin internet");
      if (name != null) {
        changeRegisterName(name);
        textNameController.text = name;
        print("Valor namecontrolller:" + _nameController.value);
      } else {
        changeRegisterName("");
      }

      if (email != null) {
        changeRegisterEmail(email);
      } else {
        changeRegisterEmail("");
      }

      if (phone != null) {
        changeRegisterPhone(phone);
      } else {
        changeRegisterPhone("");
      }
    }
  }

  Future<UserModel.User> register(String zone) async {
    print("Entró a Register");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseAuth.UserCredential credentials;
    UserModel.User currentUser;
    try {
      credentials = await _repository.register(
          email: _emailController.value, password: _passwordController.value);

      await _repository
          .updateUserData(data: {"displayName": _nameController.value});

      currentUser = UserModel.User(
          credentials.user.uid, _nameController.value, _emailController.value,
          phoneNumber: zone + _phoneController.value);

      await _repository.createUser(currentUser: currentUser);
      await credentials.user.sendEmailVerification();
    } on FirebaseAuth.FirebaseException catch (e) {
      var message = "";
      if (e.code == "weak-password") {
        message = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        message = "The account already exists for that email.";
      } else if (e.code == "permission-denied") {
        message = "You do not have permission to perform this.";
      }
      return Future.error(message);
    } catch (e) {
      print(e.toString());
    }

    //TODO comment preferences use
    await prefs.setString('regEmail', "");
    await prefs.setString('regName', "");
    await prefs.setString('regPhone', "");
    await prefs.setBool('was_offline', false);

    //TODO Reset text editing controllers
    textNameController.text = "";

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
