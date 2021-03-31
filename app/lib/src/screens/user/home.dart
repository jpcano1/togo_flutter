import '../../widgets/button.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart' as UserModel;
import 'profile.dart';

class HomeScreen extends StatelessWidget {
  final UserModel.User currentUser;

  HomeScreen(this.currentUser);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.primaryVariant,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              "Welcome, ${this.currentUser.name}",
              style: Theme.of(context).textTheme.headline5.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.width * 0.055),
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
                  onPressed: () => true,
                  minWidth: 150,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.width * 0.055),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/dog-house.png",
                  width: size.width * 0.3,
                ),
                Padding(
                  padding: EdgeInsets.all(size.width * 0.05),
                ),
                AppButton(
                  color: Theme.of(context).colorScheme.secondary, 
                  text: "Services", 
                  onPressed: () => true,
                  minWidth: 150,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.width * 0.055),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/chat-box.png",
                  width: size.width * 0.3,
                ),
                Padding(
                  padding: EdgeInsets.all(size.width * 0.05),
                ),
                AppButton(
                  color: Theme.of(context).colorScheme.secondary, 
                  text: "Chat", 
                  onPressed: () => true,
                  minWidth: 150,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.width * 0.055),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/user.png",
                  width: size.width * 0.3,
                ),
                Padding(
                  padding: EdgeInsets.all(size.width * 0.05),
                ),
                AppButton(
                  color: Theme.of(context).colorScheme.secondary, 
                  text: "Profile", 
                  onPressed: () => Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (materialPageRouteContext) => ProfileScreen(this.currentUser)
                    )
                  ),
                  minWidth: 150,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.width * 0.055),
            child: TextButton(
              onPressed: () => true, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 3.0),
                    child: Text(
                      "Log Out",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Icon(
                    Icons.logout, 
                    color: Colors.black,
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