import './models/user.dart' as UserModel;
import './models/pet.dart' as PetModel;

// Screens
import './screens/services/services.dart';
import './screens/services/store_vet/store_vet_list.dart';
import './screens/welcome.dart';
import './screens/login.dart';
import './screens/register.dart';

// Widgets
import './widgets/theme.dart';

// BLoC Provider
import './blocs/provider.dart' as provider;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
          "/register": (_) => RegisterScreen(),
          "/services": (_) => ServicesScreen(),
          "/services/vets": (_) => StoreVetListScreen(),
          // "/": (_) => StoreVetListScreen(),
        },
      )
    );
  }
}