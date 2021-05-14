import 'package:app/src/bloc/blocs/pet/create_pet_bloc.dart';
import 'package:app/src/bloc/blocs/qr_scanner/qr_scanner_bloc.dart';
import 'package:app/src/screens/pet/pet_register.dart';
import 'package:app/src/screens/services/store_vet/store_vet_creation.dart';
import 'package:app/src/screens/user/home.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
              FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
              FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
              final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
              if (firebaseAuth.currentUser != null) {
                return HomeScreen(analytics: analytics,observer: observer,);
              }
              return WelcomeScreen(analytics: analytics, observer: observer,);
            }
            return Text("Loading");
          },
        ),
        "/home": (_) => HomeScreen(analytics: analytics,observer: observer,),
        "/login": (_) => provider.Provider<LoginBloc>(
          bloc: LoginBloc(),
          child: LoginScreen(analytics: analytics, observer: observer)
        ),
        "/register": (_) => provider.Provider<RegisterBloc>(
          bloc: RegisterBloc(),
          child: RegisterScreen(analytics: analytics, observer: observer),
        ),
        "/services": (_) => ServicesScreen(analytics: analytics, observer: observer),
        "/services/vets": (_) => StoreVetListScreen(analytics: analytics, observer: observer),
        "/services/vets/create": (_) => StoreVetCreationScreen(analytics: analytics, observer: observer,),
        "/qr_scanner": (_) => provider.Provider(
          bloc: QRScannerBloc(), 
          child: QRScannerScreen(analytics: analytics, observer: observer,)
        ),
        "/pet/register": (_) => provider.Provider<CreatePetBloc>(
          bloc: CreatePetBloc(),
          child: PetRegisterScreen(analytics: analytics, observer: observer,),
        ),
      },
    );


  }
}