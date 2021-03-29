import './screens/register.dart';
import 'package:flutter/material.dart';
import './screens/home.dart';
import './widgets/theme.dart';
import './screens/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: basicTheme(),
      routes: {
        "/": (_) => HomeScreen(),
        "/login": (_) => LoginScreen(),
        "/register": (_) => RegisterScreen()
      },
    );
  }
}