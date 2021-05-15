import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/user/profile_bloc.dart';
import 'package:app/src/screens/pet/pet_detail.dart';
import 'package:app/src/screens/welcome.dart';
import 'package:app/src/utils/checkConnection.dart';
import 'package:app/src/widgets/spinner.dart';
import 'package:app/src/widgets/toast_alert.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/pet.dart';
import '../../models/user.dart' as UserModel;
import '../../models/store_vet.dart' as StoreVetModel;
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ProfileScreen({this.analytics, this.observer});

  Future <void> _setCurrentScreen() async{
    await analytics.setCurrentScreen(screenName: "ProfileView");
  }

  Future <void> _setEvent() async{
    await analytics.logEvent(name: "resend_email_verification", parameters: null);
  }

  @override
  Widget build(BuildContext context) {
    _setCurrentScreen();
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
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return StreamBuilder(
                stream: bloc.userOut,
                builder: (streamContext, streamSnaphot) {
                  if (streamSnaphot.hasData) {
                    return builBody(
                        streamContext, streamSnaphot.data, bloc, snapshot.data);
                  }
                  return Center(
                    child: LoadingSpinner(),
                  );
                });
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error));
          }
          return Center(
            child: LoadingSpinner(),
          );
        },
      ),
    );
  }

  builBody(BuildContext context, profileData, ProfileBloc bloc, verified) {
    var currentUser;
    if (profileData["petOwner"]) {
      currentUser = UserModel.User.fromMap(profileData);
    } else {
      currentUser = StoreVetModel.StoreVet.fromMap(profileData);
    }

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
              margin: EdgeInsets.only(
                  top: spaceBetween),
              child: verified
                  ? Icon(Icons.verified)
                  : TextButton(
                      onPressed: () async {
                        _setEvent();
                        bool connected = await checkConnectivity();
                        if (connected) {
                          bloc.sendVerificationEmail().then((_) {
                            showToast(
                                "Email sent, please check your inbox", context);
                          }).catchError((error) {
                            showToast(error, context);
                          });
                        } else {
                          _noConnectionDialog(context);
                        }
                      },
                      child: Text(
                        "Resend verification email",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.black),
                      ))),
          Container(
            margin: EdgeInsets.only(top: spaceBetween),
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.black, width: 1.0))),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(spaceBetween),
                      child: Text(
                        "Name: ${currentUser.name}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: spaceBetween,
                          bottom: spaceBetween,
                          left: spaceBetween),
                      child: Text(
                        "Phone number: ${currentUser.phoneNumber}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => true,
                ))
              ],
            ),
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.all(10.0),
            child: Text(currentUser.petOwner ? "My Pets:" : "My Locations",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.black)),
          ),
          currentUser.petOwner
              ? buildPets(size, bloc)
              : buildLocation(size, currentUser.locations),
          currentUser.petOwner
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Theme.of(context).colorScheme.secondaryVariant),
                  margin: EdgeInsets.only(top: size.width * 0.055),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () async {
                      bool connected = await checkConnectivity();
                      if (connected) {
                        await Navigator.pushNamed(context, "/pet/register");
                        await bloc.listPets();
                      } else {
                        _noConnectionDialog(context);
                      }
                    },
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(top: size.width * 0.055),
            child: TextButton(
              onPressed: () async {
                bool connected = await checkConnectivity();
                if (connected) {
                  await _firebaseAuth.signOut();
                  showToast("You've been logged out", context);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      ModalRoute.withName("/"));
                } else {
                  _noConnectionDialog(context);
                }
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

  buildLocation(Size size, locations) {
    Set<Marker> markers = {};

    int counter = 1;
    for (Map location in locations) {
      markers.add(Marker(
        markerId: MarkerId("value-${counter++}"),
        position: LatLng(location["lat"], location["lng"]),
      ));
    }
    return Expanded(
      child: GoogleMap(
        markers: markers,
        initialCameraPosition:
            CameraPosition(target: markers.first.position, zoom: 14),
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
        },
      ),
    );
  }

  buildPets(Size size, ProfileBloc bloc) {
    return Expanded(
        child: Container(
            width: size.width * 0.8,
            child: FutureBuilder(
              future: bloc.listPets(),
              builder: (futureContext, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return StreamBuilder(
                    stream: bloc.petListOut,
                    builder: (BuildContext streamContext,
                        AsyncSnapshot streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return builPetList(streamContext, streamSnapshot.data);
                      }
                      if (streamSnapshot.hasError) {
                        return Center(
                          child: Text(streamSnapshot.error),
                        );
                      }
                      return Center(child: LoadingSpinner());
                    },
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error,
                        style: TextStyle(color: Colors.black)),
                  );
                }
                return Center(child: LoadingSpinner());
              },
            )));
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
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.black),
            ),
            subtitle: Text(
              "Age: ${pet.age} years",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.black),
            ),
            leading: CircleAvatar(
              backgroundImage: image,
            ),
            onTap: () {
              checkConnectivity().then((connected) {
                if (connected) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PetDetailScreen(pet)));
                } else {
                  _noConnectionDialog(context);
                }
              });
            },
          ),
        );
      },
    );
  }

  //TODO check reused code
  _noConnectionDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "No internet connection",
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You don\'t have an internet connection, try again later.',
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.black,
              ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }
}
