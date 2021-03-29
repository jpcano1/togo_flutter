import './screens/register.dart';
import 'package:flutter/material.dart';
import './screens/home.dart';
import './widgets/theme.dart';
import './screens/login.dart';
import './blocs/provider.dart' as provider;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return provider.Provider(
      child: MaterialApp(
        theme: basicTheme(),
        routes: {
          "/": (_) => HomeScreen(),
          "/login": (_) => LoginScreen(),
          "/register": (_) => RegisterScreen()
        },
      )
    );
  }
}