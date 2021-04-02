import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/pet.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart' as UserModel;

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserModel.User currentUser;

  ProfileScreen(this.currentUser);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final spaceBetween = size.width * 0.03;

    final String defaultPetImage = "assets/icons/scottish-fold-cat.png";
    final String defaultUserImage = "assets/icons/user.png";
    var userImage;

    if (this.currentUser.imagePath.isEmpty) {
      userImage = AssetImage(defaultUserImage);
    } else {
      userImage = NetworkImage(this.currentUser.imagePath);
    }

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
              backgroundImage: userImage,
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
            ),
            Container(
              width: size.width,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "My Pets:",
                style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.black
                )
              ),
            ),
            Expanded(
              child: Container(
                width: size.width * 0.8,
                child: this.currentUser.pets.length > 0? ListView.builder(
                  itemCount: this.currentUser.pets.length,
                  itemBuilder: (BuildContext listContext, int index) {
                    Pet pet = this.currentUser.pets[index];
                    AssetImage image;

                    if (pet.imagePath.isNotEmpty) {
                      image = AssetImage(pet.imagePath);
                    } else {
                      image = AssetImage(defaultPetImage);
                    }
                    return Card(
                      color: Theme.of(context).colorScheme.surface,
                      elevation: 2.0,
                      child: ListTile(
                        title: Text(
                          pet.name,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black
                          ),
                        ),
                        subtitle: Text(
                          "Age: ${pet.age} years",
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: image,
                        ),
                        onTap: () => true,
                      ),
                    );
                  },
                ): null,
              )
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Theme.of(context).colorScheme.secondaryVariant
              ),
              margin: EdgeInsets.only(top: size.width * 0.055),
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white), 
                onPressed: () => true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.width * 0.055),
              child: TextButton(
                onPressed: () {
                  _firebaseAuth.signOut();
                  Fluttertoast.showToast(
                    msg: "You've been logged out",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  );
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                }, 
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
      ),
    );
  }
}