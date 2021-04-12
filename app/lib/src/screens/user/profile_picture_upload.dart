import 'dart:io';

import 'package:app/src/screens/user/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/notification_dialog.dart';
import '../../widgets/spinner.dart';
import '../../widgets/app_bar.dart';
import '../../utils/permissions.dart';
import '../../widgets/button.dart';
import '../../bloc/bloc_provider.dart';
import '../../bloc/blocs/update_profile_picture_bloc.dart';
import '../../models/user.dart' as UserModel;

import 'package:flutter/material.dart';

class ProfilePictureUploadScreen extends StatefulWidget {
  final UserModel.User currentUser;

  ProfilePictureUploadScreen(this.currentUser);

  @override
  _ProfilePictureUploadScreenState createState() => _ProfilePictureUploadScreenState();
}

class _ProfilePictureUploadScreenState extends State<ProfilePictureUploadScreen> {
  File picture;
  String filename;
  String nextButtonText = "Next";
  bool allowed = false;

  @override
  Widget build(BuildContext context) {
    final UserModel.User currentUser = widget.currentUser;

    final size = MediaQuery.of(context).size;
    final String imageUrl = "assets/icons/profile.png";
    final bloc = Provider.of<UpdateProfilePictureBloc>(context);

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
                              this.filename = currentUser.id + "." + this.picture.path
                              .split("/").last.split(".").last;
                              bloc.profileImageChange([this.filename, this.picture]);
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
                    child: StreamBuilder(
                      stream: bloc.profileImageOut,
                      builder: (streamContext, snapshot) {
                        return AppButton(
                          color: Theme.of(context).colorScheme.primary,
                          text: nextButtonText,
                          onPressed: allowed? () async {
                            dialog(context, content: LoadingSpinner());
                            var streamList = snapshot.data;

                            String downloadPath;

                            try {
                              downloadPath = await bloc.upload(streamList[0], streamList[1]);
                              Navigator.pop(streamContext);
                            } catch (error) {
                              Navigator.pop(streamContext);
                            }
                            Fluttertoast.showToast(
                              msg: "User created successfully!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              textColor: Colors.white,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                            );
                            currentUser.imagePath = downloadPath;
                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(
                                builder: (_) => HomeScreen()
                              )
                            );
                          }: null,
                        );
                      },
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