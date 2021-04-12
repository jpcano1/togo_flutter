import 'package:app/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class PetPictureUploadPicture extends StatefulWidget {
  @override
  _PetPictureUploadPictureState createState() => _PetPictureUploadPictureState();
}

class _PetPictureUploadPictureState extends State<PetPictureUploadPicture> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String imageUrl = "assets/icons/profile.png";
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.secondary, 
        iconColor: Colors.black
      ),
      body: Container(
        
      ),
    );
  }
}