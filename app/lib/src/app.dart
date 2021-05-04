import 'package:app/src/bloc/blocs/pet/create_pet_bloc.dart';
import 'package:app/src/screens/pet/pet_register.dart';
import 'package:app/src/screens/services/store_vet/add_marker.dart';
import 'package:app/src/screens/services/store_vet/store_vet_creation.dart';
import 'package:app/src/screens/user/home.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './models/user.dart' as UserModel;
import './models/pet.dart' as PetModel;

// Screens
import './screens/services/services.dart';
import './screens/services/store_vet/store_vet_list.dart';
import './screens/welcome.dart';
import './screens/login.dart';
import './screens/register.dart';
import './screens/user/qr_scanner.dart';

// Widgets
import './widgets/theme.dart';

// BLoCs
import './bloc/bloc_provider.dart' as provider;
import './bloc/blocs/login_bloc.dart';
import './bloc/blocs/register_bloc.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    final FirebaseAnalytics analytics = FirebaseAnalytics();
    final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

    return MaterialApp(
      theme: basicTheme(),
      navigatorObservers:  <NavigatorObserver>[observer],
      routes: {
        "/": (_) => FutureBuilder(
          future: _initialization,
          builder: (futureContext, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error);
            } 
            if (snapshot.connectionState == ConnectionState.done) {
              final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
              if (firebaseAuth.currentUser != null) {
                return HomeScreen();
              }
              return WelcomeScreen();
            }
            return Text("Loading");
          },
        ),
        "/home": (_) => HomeScreen(),
        "/login": (_) => provider.Provider<LoginBloc>(
          bloc: LoginBloc(),
          child: LoginScreen(analytics: analytics, observer: observer)
        ),
        "/register": (_) => provider.Provider<RegisterBloc>(
          bloc: RegisterBloc(),
          child: RegisterScreen(),
        ),
        "/services": (_) => ServicesScreen(analytics: analytics, observer: observer),
        "/services/vets": (_) => StoreVetListScreen(),
        "/services/vets/create": (_) => StoreVetCreationScreen(),
        "/qr_scanner": (_) => QRScannerScreen(),
        "/pet/register": (_) => provider.Provider<CreatePetBloc>(
          bloc: CreatePetBloc(),
          child: PetRegisterScreen(),
        ),
      },
    );
  }
}