import 'package:flutter/material.dart';
import '../models/user.dart' as UserModel;

class HomeScreen extends StatelessWidget {
  final UserModel.User currentUser;

  HomeScreen({this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryVariant,
        child: Column(
          children: [
            Text(
              "Welcome, ${this.currentUser.name}",
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