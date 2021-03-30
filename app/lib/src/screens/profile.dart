import 'package:flutter/material.dart';
import '../models/user.dart' as UserModel;

class ProfileScreen extends StatelessWidget {
  final UserModel.User currentUser;

  ProfileScreen({this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
    );
  }
}