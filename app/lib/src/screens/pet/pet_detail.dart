import 'package:app/src/utils/night_mode.dart';
import 'package:app/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import '../../models/pet.dart' as PetModel;

class PetDetailScreen extends StatelessWidget {
  final PetModel.Pet currentPet;

  PetDetailScreen(this.currentPet);

  @override
  Widget build(BuildContext context) {
    final String defaultPetImage = "assets/icons/scottish-fold-cat.png";
    final size = MediaQuery.of(context).size;
    bool nightMode = isNightMode();
    var petImage;

    if (currentPet.imagePath.isEmpty) {
      petImage = AssetImage(defaultPetImage);
    } else {
      petImage = NetworkImage(currentPet.imagePath);
    }

    return Scaffold(
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.secondary, 
        iconColor: nightMode? Colors.white: Colors.black
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: size.width * 0.05),
              margin: EdgeInsets.only(bottom: size.width * 0.05),
              child: Text(
                "${currentPet.name}",
                style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.black
                ),
              ),
            ),
            CircleAvatar(
              backgroundImage: petImage,
              maxRadius: size.width * 0.25,
            )
          ],
        ),
      ),
    );
  }
}