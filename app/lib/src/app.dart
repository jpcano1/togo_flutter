import 'package:app/src/models/pet.dart';
import 'package:app/src/screens/services/services.dart';
import './screens/services/store_vet/store_vet_list.dart';
import './screens/user/home.dart';
import './screens/user/profile.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/register.dart';
import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import './widgets/theme.dart';
import './screens/login.dart';
import './blocs/provider.dart' as provider;
import './models/user.dart' as UserModel;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return provider.Provider(
      child: MaterialApp(
        theme: basicTheme(),
        routes: {
          "/home": (_) => FutureBuilder(
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
          "/register": (_) => RegisterScreen(),
          "/services": (_) => ServicesScreen(),
          // "/services/vets": (_) => StoreVetListScreen(),
          "/": (_) => StoreVetListScreen()
        },
      )
    );
  }
}