import 'package:flutter/material.dart';
import '../models/user.dart' as UserModel;

class ProfileScreen extends StatelessWidget {
  final UserModel.User currentUser;

  ProfileScreen({this.currentUser});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final spaceBetween = size.width * 0.03;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryVariant,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/icons/user.png"),
              maxRadius: size.width * 0.25,
            ),
            Container(
              margin: EdgeInsets.only(top: spaceBetween),
              decoration: BoxDecoration(border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.black, 
                  width: 1.0
                )
              )),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(spaceBetween),
                        child: Text(
                          "Name: ${this.currentUser.name}",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.black
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: spaceBetween, 
                          right: spaceBetween,
                          left: spaceBetween
                        ),
                        child: Text(
                          "Phone number: ${this.currentUser.phoneNumber}",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.black,
                            fontSize: 17
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => true,
                    )
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