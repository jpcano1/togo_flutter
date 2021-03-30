import 'package:flutter/material.dart';
import '../widgets/button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: Theme.of(context).colorScheme.primaryVariant,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
          ),
          Text(
            "Togo", 
            style: Theme.of(context).textTheme.headline4.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold
            )
          ),
          Padding(
            padding: EdgeInsets.all(30.0)
          ),
          Image.asset(
            "assets/icons/app-icon.png",
            width: size.width,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    color: Theme.of(context).colorScheme.primary, 
                    text: "Login", 
                    onPressed: () => Navigator.pushNamed(context, "/login"),
                    minWidth: size.width * 0.45,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                  AppButton(
                    color: Theme.of(context).colorScheme.secondary, 
                    text:"Register", 
                    onPressed: () => Navigator.pushNamed(context, "/register"),
                    minWidth: MediaQuery.of(context).size.width * 0.45,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}