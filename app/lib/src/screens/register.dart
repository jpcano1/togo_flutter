import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/button.dart';
import '../models/user.dart' as UserModel;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import '../blocs/bloc.dart';
import '../utils/notification_dialog.dart';
import '../blocs/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection("User");
  String zone;

  @override
  void initState() {
    zone = "+57";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Text(
              "Register",
              style: Theme.of(context).textTheme.headline4.copyWith(
                color: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: StreamBuilder(
                stream: bloc.registerName,
                builder: (streamContext, snapshot) {
                  return TextField(
                    onChanged: bloc.changeRegisterName,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "John Doe",
                      errorText: snapshot.error
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: StreamBuilder(
                stream: bloc.registerEmail,
                builder: (streamContext, snapshot) {
                  return TextField(
                    onChanged: bloc.changeRegisterEmail,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "example@mail.com",
                      errorText: snapshot.error
                    ),
                  );
                },
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Row(
                children: [
                  CountryCodePicker(
                    initialSelection: "CO",
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                    dialogTextStyle: TextStyle(
                      color: Colors.black,
                    ),
                    searchStyle: TextStyle(
                      color: Colors.black,
                    ),
                    dialogSize: Size(size.width * 0.8, size.height * 0.7),
                    onChanged: (CountryCode value) => setState(() => zone = value.dialCode),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: bloc.registerPhone,
                      builder: (streamContext, snapshot) {
                        return TextField(
                          onChanged: bloc.changeRegisterPhone,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "+57 (123) 123 1234",
                            errorText: snapshot.error
                          ),
                        );
                      },
                    )
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: StreamBuilder(
                stream: bloc.registerPassword,
                builder: (streamContext, snapshot) {
                  return TextField(
                    onChanged: bloc.changeRegisterPassword,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "password",
                      errorText: snapshot.error
                    ),
                  );
                },
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: StreamBuilder(
                stream: bloc.registerSubmit,
                builder: (streamContext, snapshot) {
                  return AppButton(
                    color: Theme.of(streamContext).colorScheme.primary,
                    text: "Next",
                    onPressed: snapshot.hasData? register(streamContext, bloc): null,
                    minWidth: size.width,
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }

  register(BuildContext context, Bloc bloc) {
    _register() async {
      var validData = bloc.register();
      try {
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: validData["email"], 
          password: validData["password"]
        );
        await _firebaseAuth.currentUser.updateProfile(displayName: validData["name"]);
      } on FirebaseAuthException catch(e) {
        if (e.code == "weak-password") {
          return dialog(context, "The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          return dialog(context, "The account already exists for that email.");
        }
      } catch(e) {
        print(e.toString());
      }

      var currentUser = UserModel.User(
        validData["name"], validData["email"], 
        phoneNumber: this.zone + validData["phone"]
      );

      users.add(currentUser.toMap())
      .then((result) async {
        await _firebaseAuth.currentUser.sendEmailVerification();
        dialog(context, "User added, verify your email inbox");

        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (materialPageRouteContext) => HomeScreen(
              currentUser: currentUser
            )
          )
        );
      })
      .catchError((FirebaseException error) {
        if (error.code == "permission-denied") {
          return dialog(context, "You do not have permission to perform this.");
        }
      });
    }
    return _register;
  }
}