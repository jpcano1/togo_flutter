import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/user/profile_bloc.dart';
import 'package:app/src/utils/checkConnection.dart';
import 'package:app/src/widgets/toast_alert.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/button.dart';
import '../welcome.dart';
import 'profile.dart';

/// Wrapper for stateful functionality to provide onInit calls in stateles widget
class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;
  const StatefulWrapper({@required this.onInit, @required this.child});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class HomeScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  HomeScreen({this.analytics, this.observer});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //TODO uncomment code if necessary
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String username;
  Future<void> _setCurrentScreen() async {
    bool connected = await checkConnectivity();
    if (connected) {
      await widget.analytics.setCurrentScreen(screenName: "Home");
    }
  }

  @override
  void initState() {
    super.initState();
    loadUsername().then((value) {
      username = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _setCurrentScreen();

    return WillPopScope(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          body: SingleChildScrollView(
              child: Container(
            color: Theme.of(context).colorScheme.primaryVariant,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: size.height * 0.08),
                  child: Text(
                    // "Welcome, ${this._firebaseAuth.currentUser.displayName}",
                    "Welcome, " + username,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.width * 0.055),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/pet-locator.png",
                        width: size.width * 0.3,
                      ),
                      Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                      ),
                      AppButton(
                        color: Theme.of(context).colorScheme.secondary,
                        text: "Find my Pet",
                        onPressed: () => true,
                        minWidth: 150,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.width * 0.055),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/dog-house.png",
                        width: size.width * 0.3,
                      ),
                      Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                      ),
                      AppButton(
                        color: Theme.of(context).colorScheme.secondary,
                        text: "Services",
                        onPressed: () {
                          checkConnectivity().then((connected) {
                            if (connected) {
                              Navigator.pushNamed(context, "/services");
                            } else {
                              _noConnectionDialog(context);
                            }
                          });
                        },
                        minWidth: 150,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.width * 0.055),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/chat-box.png",
                        width: size.width * 0.3,
                      ),
                      Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                      ),
                      AppButton(
                        color: Theme.of(context).colorScheme.secondary,
                        text: "Chat",
                        onPressed: () => true,
                        minWidth: 150,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.width * 0.055),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/user.png",
                        width: size.width * 0.3,
                      ),
                      Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                      ),
                      AppButton(
                        color: Theme.of(context).colorScheme.secondary,
                        text: "Profile",
                        onPressed: () async {
                          bool onlineLog = await onlineLogin();
                          bool connected = await checkConnectivity();
                          if (onlineLog) {
                            if (connected) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (materialPageRouteContext) =>
                                          Provider(
                                              bloc: ProfileBloc(),
                                              child: ProfileScreen(
                                                analytics: widget.analytics,
                                                observer: widget.observer,
                                              ))));
                            } else {
                              _noConnectionDialog(context);
                            }
                          } else {
                            _offlineLoginDialog(context);
                          }
                        },
                        minWidth: 150,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.width * 0.055),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      checkConnectivity().then((connected) {
                        if (connected) {
                          Navigator.pushNamed(context, "/qr_scanner");
                        } else {
                          _noConnectionDialog(context);
                        }
                      });
                    },
                    icon: Icon(Icons.qr_code),
                    label: Text("QR Scan"),
                  ),
                ),
              ],
            ),
          )),
        ),
        onWillPop: () => Future.value(false));
  }

  //TODO check reused code
  _noConnectionDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "No internet connection",
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You don\'t have an internet connection, try again later.',
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.black,
              ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  //TODO merge both dialogs into one method
  _offlineLoginDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "No internet connection",
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You logged in without internet connection and cannot access your profile, would you like to go back to the welcome screen?',
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.black,
              ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              showToast("Redirected to welcome screen", context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  ModalRoute.withName("/"));
            },
            child: Text('Yes'),
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

  Future<bool> onlineLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("online_log");
  }

  Future<String> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('logName');
    if (name != null && name.isNotEmpty) {
      return name;
    } else {
      return "";
    }
  }
}
