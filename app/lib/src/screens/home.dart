import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final User currentUser;

  HomeScreen({this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryVariant,
        child: Column(
          children: [
            Text(
              "Welcome, ${this.currentUser.displayName}",
              style: Theme.of(context).textTheme.headline4.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
    );
  }
}