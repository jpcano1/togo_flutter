import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/user/profile_bloc.dart';
import 'package:app/src/utils/checkConnection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/button.dart';
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
                        onPressed: () =>
                            Navigator.pushNamed(context, "/services"),
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
                        onPressed: () => Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (materialPageRouteContext) => Provider(
                              bloc: ProfileBloc(), 
                              child: ProfileScreen(analytics: analytics, observer: observer,)
                            )
                          )
                        ),
                        minWidth: 150,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.width * 0.055),
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, "/qr_scanner"),
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
