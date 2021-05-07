import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/user/profile_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/button.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  HomeScreen({this.analytics, this.observer});

  Future <void> _setCurrentScreen() async{
    await analytics.setCurrentScreen(screenName: "Home");
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
                    "Welcome, ${this._firebaseAuth.currentUser.displayName}",
                    style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
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
                        onPressed: () => Navigator.pushNamed(
                          context, 
                          "/services"
                        ),
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
                              child: ProfileScreen()
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
                    onPressed: () => Navigator.pushNamed(context, "/qr_scanner"),
                    icon: Icon(Icons.qr_code),
                    label: Text("QR Scan"),
                  ),
                ),
              ],
            ),
          )
        ),
      ), 
      onWillPop: () => Future.value(false)
    );
  }
}