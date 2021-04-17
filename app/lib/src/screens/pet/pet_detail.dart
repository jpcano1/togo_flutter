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
              alignment: Alignment.centerLeft,
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
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                top: size.height * 0.03,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black,
                    width: 1.0
                  )
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Breed: ${currentPet.breed}",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black
                    )
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Text(
                    "Height: ${currentPet.height}",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black
                    )
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Text(
                    "Weight: ${currentPet.weight}",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black
                    )
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Text(
                    "Age: ${currentPet.age} years",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black
                    )
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Text(
                    "Birthday: ${currentPet.birthday}",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => true,
        child: Icon(Icons.edit),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}