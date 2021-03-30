import 'package:firebase_core/firebase_core.dart';

import './screens/register.dart';
import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import './widgets/theme.dart';
import './screens/login.dart';
import './blocs/provider.dart' as provider;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return provider.Provider(
      child: MaterialApp(
        theme: basicTheme(),
        routes: {
          "/": (_) => FutureBuilder(
            future: _initialization,
            builder: (futureContext, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error);
              } 
              if (snapshot.connectionState == ConnectionState.done) {
                return WelcomeScreen();
              }
              return Text("Loading");
            },
          ),
          "/login": (_) => LoginScreen(),
          "/register": (_) => RegisterScreen()
        },
      )
    );
  }
}