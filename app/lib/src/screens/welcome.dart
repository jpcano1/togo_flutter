import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import '../utils/checkConnection.dart';
import '../widgets/button.dart';

class WelcomeScreen extends StatelessWidget {

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  WelcomeScreen({this.analytics, this.observer});

  Future <void> _setCurrentScreen() async{
    await analytics.setCurrentScreen(screenName: "Welcome");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _setCurrentScreen();
    return Container(
      color: Theme.of(context).colorScheme.primaryVariant,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
          ),
          Text("Togo",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
          Padding(padding: EdgeInsets.all(30.0)),
          Image.asset(
            "assets/icons/app-icon.png",
            width: size.width,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    color: Theme.of(context).colorScheme.primary,
                    text: "Login",
                    onPressed: () => Navigator.pushNamed(context, "/login"),
                    minWidth: size.width * 0.45,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                  AppButton(
                    color: Theme.of(context).colorScheme.secondary,
                    text: "Register",
                    onPressed: () {
                      checkConnectivity().then((connected) {
                        if (!connected) {
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
                                'Keep in mind you don\'t have an internet connection at the moment, you may proceed but credentials will be saved locally.',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushNamed(context, "/register");
                                  },
                                  child: Text('Continue'),
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
                        } else {
                          Navigator.pushNamed(context, "/register");
                        }
                      });
                    },
                    minWidth: MediaQuery.of(context).size.width * 0.45,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
