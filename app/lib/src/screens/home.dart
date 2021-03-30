import 'package:app/src/widgets/button.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as UserModel;

class HomeScreen extends StatelessWidget {
  final UserModel.User currentUser;

  HomeScreen({this.currentUser});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
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
                    onPressed: () => true
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}