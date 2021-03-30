import 'package:app/src/blocs/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blocs/provider.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
              "Register",
              style: Theme.of(context).textTheme.headline4.copyWith(
                color: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: StreamBuilder(
                stream: bloc.email,
                builder: (streamContext, snapshot) {
                  return TextField(
                    onChanged: bloc.changeEmail,
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
                stream: bloc.password,
                builder: (streamContext, snapshot) {
                  return TextField(
                    onChanged: bloc.changePassword,
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
                    color: Theme.of(context).colorScheme.primary,
                    text: "Next",
                    onPressed: snapshot.hasData? () async {
                      var validData = bloc.register();
                      try {
                        UserCredential credentials = await _firebaseAuth.createUserWithEmailAndPassword(
                          email: validData["email"], 
                          password: validData["password"]
                        );
                      } on FirebaseAuthException catch(e) {
                        if (e.code == "weak-password") {
                          dialog(streamContext, "The password provided is too weak.");
                        } else if (e.code == 'email-already-in-use') {
                          dialog(streamContext, "The account already exists for that email.");
                        }
                      }
                    }: null,
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

  dialog(context, error) {
    showDialog(
      context: context, 
      builder: (dialogContext) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(error),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text("Ok"),
                  )
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}