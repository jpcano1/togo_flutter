import 'package:app/src/utils/checkConnection.dart';
import 'package:app/src/widgets/toast_alert.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './user/home.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/blocs/login_bloc.dart';
import '../utils/night_mode.dart';
import '../utils/notification_dialog.dart';
import '../widgets/app_bar.dart';
import '../widgets/button.dart';
import '../widgets/spinner.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  LoginScreen({this.analytics, this.observer});

  Future<void> _logLogin() async {
    await analytics.logLogin();
  }

  Future<void> _setCurrentScreen() async {
    await analytics.setCurrentScreen(screenName: "Login");
  }

  @override
  Widget build(BuildContext context) {
    bool nightMode = isNightMode();
    final bloc = Provider.of<LoginBloc>(context);
    final size = MediaQuery.of(context).size;

    _setCurrentScreen();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          iconColor: nightMode ? Colors.white : Colors.black),
      body: Container(
        alignment: Alignment.centerLeft,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Text(
              "Login",
              style: Theme.of(context).textTheme.headline4.copyWith(
                    color: nightMode ? Colors.white : Colors.black,
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
                      cursorColor: nightMode ? Colors.white : Colors.black,
                      style: TextStyle(
                        color: nightMode ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                          hintText: "example@mail.com",
                          errorText: snapshot.error),
                    );
                  },
                )),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: StreamBuilder(
                  stream: bloc.loginPassword,
                  builder: (streamContext, snapshot) {
                    return TextField(
                      onChanged: bloc.changeLoginPassword,
                      cursorColor: nightMode ? Colors.white : Colors.black,
                      style: TextStyle(
                        color: nightMode ? Colors.white : Colors.black,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "password", errorText: snapshot.error),
                    );
                  },
                )),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: StreamBuilder(
                stream: bloc.loginSubmit,
                builder: (streamContext, snapshot) {
                  return AppButton(
                    color: Theme.of(context).colorScheme.primary,
                    text: "Log In",
                    onPressed: snapshot.hasData
                        ? () async {
                            bool connected = await checkConnectivity();
                            if (connected) {
                              dialog(context, content: LoadingSpinner());
                              try {
                                var blocData = await bloc.login();

                                Navigator.pop(streamContext);
                                if (!blocData["verified"]) {
                                  showToast(
                                      "You are not verified, please go check your email",
                                      context);
                                }

                                //_logLogin();

                                Navigator.pushReplacement(
                                    streamContext,
                                    MaterialPageRoute(
                                        builder: (_) => HomeScreen()));
                              } catch (error) {
                                Navigator.pop(streamContext);
                                Fluttertoast.showToast(
                                  msg: error,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  textColor: Colors.white,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                );
                                return;
                              }
                            } else {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    "No internet connection",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                    'Keep in mind you don\'t have an internet connection at the moment, only last online session credentials are valid.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        //Method to login while offline
                                        String offlineLogResult =
                                            await bloc.offlineLogin();

                                        Navigator.of(context).pop();
                                        if (offlineLogResult == "valid") {
                                          showToast(
                                              "You are logged without internet connection",
                                              context);
                                          Navigator.pushReplacement(
                                              streamContext,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      HomeScreen()));
                                        } else {
                                          showToast(
                                              "Wrong email or password from last saved session",
                                              context);
                                        }
                                      },
                                      child: Text('Log in'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        : null,
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
