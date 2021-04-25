import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/user/profile_bloc.dart';
import 'package:app/src/screens/pet/pet_detail.dart';
import 'package:app/src/screens/welcome.dart';
import 'package:app/src/widgets/spinner.dart';
import 'package:app/src/widgets/toast_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/pet.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart' as UserModel;

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProfileBloc>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryVariant,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: FutureBuilder(
        future: bloc.readUser(),
        builder: (BuildContext futureBuilderContext, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              stream: bloc.userOut,
              builder: (streamContext, streamSnaphot) {
                if (streamSnaphot.hasData) {
                  return builBody(streamContext, streamSnaphot.data, bloc);
                }
                return Center(
                  child: LoadingSpinner(),
                );
              }
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error)
            );
          }
          return Center(
            child: LoadingSpinner(),
          );
        },
      )
    );
  }

  builBody(BuildContext context, UserModel.User currentUser, ProfileBloc bloc) {
    var userImage;
    final String defaultUserImage = "assets/icons/user.png";
    if (currentUser.imagePath.isEmpty) {
      userImage = AssetImage(defaultUserImage);
    } else {
      userImage = NetworkImage(currentUser.imagePath);
    }

    final size = MediaQuery.of(context).size;
    final spaceBetween = size.width * 0.03;
    return Container(
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
                        "Name: ${currentUser.name}",
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
                        "Phone number: ${currentUser.phoneNumber}",
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
              child: FutureBuilder(
                future: bloc.listPets(),
                builder: (futureContext, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return StreamBuilder(
                      stream: bloc.petListOut,
                      builder: (BuildContext streamContext, AsyncSnapshot streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          print(streamSnapshot.data);
                          return builPetList(streamContext, streamSnapshot.data);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(streamSnapshot.error),
                          );
                        }
                        return Center(
                          child: LoadingSpinner()
                        );
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error,
                        style: TextStyle(color: Colors.black)
                      ),
                    );
                  }
                  return Center(
                    child: LoadingSpinner()
                  );
                },
              )
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
              onPressed: () async {
                await Navigator.pushNamed(context, "/pet/register");
                await bloc.listPets();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.width * 0.055),
            child: TextButton(
              onPressed: () async {
                await _firebaseAuth.signOut();
                showToast("You've been logged out", context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen()
                  ), 
                  ModalRoute.withName("/")
                );
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
    );
  }

  builPetList(BuildContext context, List pets) {
    final String defaultPetImage = "assets/icons/scottish-fold-cat.png";
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (BuildContext listContext, int index) {
        Pet pet = pets[index];
        var image;

        if (pet.imagePath.isNotEmpty) {
          image = NetworkImage(pet.imagePath);
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
            onTap: () => Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => PetDetailScreen(pet)
              )
            ),
          ),
        );
      },
    );
  }
}