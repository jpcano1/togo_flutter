import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';
import '../models/user.dart' as UserModel;
import '../blocs/bloc.dart';
import '../utils/notification_dialog.dart';
import '../utils/night_mode.dart';
import '../blocs/provider.dart';
import './user/profile_picture_upload.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection("User");
  String zone;
  bool nightMode = isNightMode();

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
          color: nightMode? Colors.white: Colors.black
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Text(
              "Register",
              style: Theme.of(context).textTheme.headline4.copyWith(
                color: nightMode? Colors.white: Colors.black,
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
                    cursorColor: nightMode? Colors.white: Colors.black,
                    style: TextStyle(
                      color: nightMode? Colors.white: Colors.black
                    ),
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
                    cursorColor: nightMode? Colors.white: Colors.black,
                    style: TextStyle(
                      color: nightMode? Colors.white: Colors.black
                    ),
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
                      color: nightMode? Colors.white: Colors.black,
                    ),
                    dialogTextStyle: TextStyle(
                      color: nightMode? Colors.white: Colors.black,
                    ),
                    searchStyle: TextStyle(
                      color: nightMode? Colors.white: Colors.black,
                    ),
                    dialogBackgroundColor: Theme.of(context).backgroundColor,
                    dialogSize: Size(size.width * 0.8, size.height * 0.7),
                    onChanged: (CountryCode value) => setState(() => zone = value.dialCode),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: bloc.registerPhone,
                      builder: (streamContext, snapshot) {
                        return TextField(
                          onChanged: bloc.changeRegisterPhone,
                          keyboardType: TextInputType.phone,
                          cursorColor: nightMode? Colors.white: Colors.black,
                          style: TextStyle(
                            color: nightMode? Colors.white: Colors.black
                          ),
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
                    cursorColor: nightMode? Colors.white: Colors.black,
                    style: TextStyle(
                      color: nightMode? Colors.white: Colors.black
                    ),
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
          return dialog(context, message: "The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          return dialog(context, message: "The account already exists for that email.");
        }
      } catch(e) {
        print(e.toString());
      }

      var currentUser = UserModel.User(
        _firebaseAuth.currentUser.uid,
        validData["name"], validData["email"], 
        phoneNumber: this.zone + validData["phone"]
      );

      users.doc(currentUser.id).set(currentUser.toMap())
      .then((_) async {
        await _firebaseAuth.currentUser.sendEmailVerification();

        Fluttertoast.showToast(
          msg: "Verify your email inbox",
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.primary,
        );

        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (_) => ProfilePictureUploadScreen(currentUser)
          )
        );
      })
      .catchError((FirebaseException error) {
        if (error.code == "permission-denied") {
          return dialog(context, message: "You do not have permission to perform this.");
        }
      });
    }
    return _register;
  }
}