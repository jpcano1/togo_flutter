import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../widgets/spinner.dart';
import '../widgets/app_bar.dart';
import '../widgets/button.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/blocs/login_bloc.dart';
import '../utils/notification_dialog.dart';
import '../models/user.dart' as UserModel;
import './user/home.dart';
import '../utils/night_mode.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    bool nightMode = isNightMode();
    final bloc = Provider.of<LoginBloc>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.background, 
        iconColor: nightMode? Colors.white: Colors.black
      ),
      body: Container(
        alignment: Alignment.centerLeft,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Text(
              "Login",
              style: Theme.of(context).textTheme.headline4.copyWith(
                color: nightMode? Colors.white: Colors.black,
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
                    cursorColor: nightMode? Colors.white: Colors.black,
                    style: TextStyle(
                      color: nightMode? Colors.white: Colors.black,
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
              child: StreamBuilder(
                stream: bloc.loginPassword,
                builder: (streamContext, snapshot) {
                  return TextField(
                    onChanged: bloc.changeLoginPassword,
                    cursorColor: nightMode? Colors.white: Colors.black,
                    style: TextStyle(
                      color: nightMode? Colors.white: Colors.black,
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
                stream: bloc.loginSubmit,
                builder: (streamContext, snapshot) {
                  return AppButton(
                    color: Theme.of(context).colorScheme.primary,
                    text: "Log In",
                    onPressed: snapshot.hasData? () async {
                      dialog(context, content: LoadingSpinner());
                      try {
                        var blocData = await bloc.login();
                        
                        Navigator.pop(streamContext);
                        if (!blocData["verified"]) {
                          Fluttertoast.showToast(
                            msg: "You are not verified, please go check your email",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.white,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          );
                        }

                        var document = blocData["document"];

                        var currentUser = UserModel.User.fromMap(document.data());

                        Navigator.pushReplacement(
                          streamContext, 
                          MaterialPageRoute(
                            builder: (materialPageRouteContext) => HomeScreen(currentUser)
                          )
                        );
                      } catch(error) {
                        Navigator.pop(streamContext);
                        Fluttertoast.showToast(
                          msg: error,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.white,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        );
                        return;
                      }
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