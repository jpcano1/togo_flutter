import 'dart:io';

import 'package:app/src/screens/user/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../widgets/app_bar.dart';
import '../../utils/permissions.dart';
import '../../widgets/button.dart';
import '../../models/user.dart' as UserModel;

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class ProfilePictureUploadScreen extends StatefulWidget {
  final UserModel.User currentUser;

  ProfilePictureUploadScreen(this.currentUser);

  @override
  _ProfilePictureUploadScreenState createState() => _ProfilePictureUploadScreenState(this.currentUser);
}

class _ProfilePictureUploadScreenState extends State<ProfilePictureUploadScreen> {
  final firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;
  final firestore.CollectionReference users = firestore.FirebaseFirestore.instance.collection("User");

  final UserModel.User currentUser;

  _ProfilePictureUploadScreenState(this.currentUser);

  File picture;
  String nextButtonText = "Next";
  bool allowed = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String imageUrl = "assets/icons/profile.png";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.background, 
        iconColor: Colors.black
      ),
      body: Container(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: size.height * 0.1),
              width: size.width * 0.8,
              alignment: Alignment.center,
              child: Card(
                elevation: 2.0,
                child: this.picture == null? Image.asset(
                  imageUrl
                ): Image.file(
                  this.picture
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: size.height * 0.01),
                    child: AppButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        uploadImage()
                          .then((File result) {
                            setState(() {
                              this.picture = result;
                              allowed = true;
                              nextButtonText = "Next";
                            });
                          })
                          .catchError((error) {
                            Fluttertoast.showToast(
                              msg: error,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              textColor: Colors.white,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                            );
                            setState(() {
                              nextButtonText = "Jump";
                              allowed = true;
                            });
                          });
                      },
                      text: "Upload",
                    ),
                  ),
                  Container(
                    child: AppButton(
                      color: Theme.of(context).colorScheme.primary,
                      text: nextButtonText,
                      onPressed: allowed? () async {
                        var downloadPath = await upload();
                        users.doc(this.currentUser.id)
                        .update({
                          "imagePath": downloadPath
                        })
                        .then((_) {
                          Fluttertoast.showToast(
                            msg: "User created successfully!",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.white,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          );
                          this.currentUser.imagePath = downloadPath;
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(this.currentUser)
                            )
                          );
                        })
                        .catchError((firestore.FirebaseException error) {
                          print(error.code);
                        });
                      }: null,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> upload() async {
    try {
      var filename = this.currentUser.id + this.picture.path
      .split("/").last.split(".").last;
      var snapshot = await _storage
      .ref()
      .child("user_pictures/pet_owner/$filename")
      .putFile(this.picture);
      return await snapshot.ref.getDownloadURL();
    } on Exception catch(e) {
      throw new Exception(e);
    }
  }
}