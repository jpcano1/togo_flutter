import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blocs/provider.dart';
import '../utils/notification_dialog.dart';
import '../models/user.dart' as UserModel;
import 'home.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: Container(
        alignment: Alignment.centerLeft,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Text(
              "Login",
              style: Theme.of(context).textTheme.headline4.copyWith(
                color: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: StreamBuilder(
                stream: bloc.loginEmail,
                builder: (streamContext, snapshot) {
                  return TextField(
                    onChanged: bloc.changeLoginEmail,
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
              child: StreamBuilder(
                stream: bloc.loginPassword,
                builder: (streamContext, snapshot) {
                  return TextField(
                    onChanged: bloc.changeLoginPassword,
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
                stream: bloc.loginSubmit,
                builder: (streamContext, snapshot) {
                  return AppButton(
                    color: Theme.of(context).colorScheme.primary,
                    text: "Log In",
                    onPressed: snapshot.hasData? () async {
                      var validData = bloc.login();
                      try {
                        await _firebaseAuth.signInWithEmailAndPassword(
                          email: validData["email"], 
                          password: validData["password"]
                        );
                      } on FirebaseAuthException catch(e) {
                        return dialog(streamContext, "Wrong email or password");
                      }

                      User user = _firebaseAuth.currentUser;

                      if (!user.emailVerified) {
                        dialog(streamContext, "You are not verified, please go check your email");
                      }

                      var currentUser = UserModel.User(user.displayName, user.email);
                      Navigator.pushReplacement(
                        streamContext, 
                        MaterialPageRoute(
                          builder: (materialPageRouteContext) => HomeScreen(
                            currentUser: currentUser
                          )
                        )
                      );
                    }: null,
                    minWidth: size.width,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}