import '../../models/pet.dart';
import '../../widgets/app_bar.dart';
import '../../utils/night_mode.dart';
import '../../utils/notification_dialog.dart';

import 'package:flutter/material.dart';

class PetRegisterScreen extends StatefulWidget {
  @override
  _PetRegisterScreenState createState() => _PetRegisterScreenState();
}

class _PetRegisterScreenState extends State<PetRegisterScreen> {
  Pet newPet = Pet(
    "--", "--", "--", 0.0, 0.0, 
    0 , "--", imagePath: "--"
  );

  @override
  Widget build(BuildContext context) {
    bool nightMode = isNightMode();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.secondary, 
        iconColor: nightMode? Colors.white: Colors.black
      ),
      body: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: size.width * 0.05),
              alignment: Alignment.centerLeft,
              child: Text(
                "New",
                style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Colors.black
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.04),
              alignment: Alignment.center,
              child: IconButton(
                icon: Image.asset(
                  "assets/icons/image.png",
                ),
                onPressed: () => true,
                iconSize: size.width * 0.4,
              ),
            ),
            Container(
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
                  TextButton(
                    onPressed: () => true,
                    child: Text(
                      "Name: ${this.newPet.name}",
                      style: TextStyle(
                        color: Colors.black
                      ),
                    )
                  ),
                  TextButton(
                    onPressed: () => true, 
                    child: Text(
                      "Breed: ${this.newPet.breed}",
                      style: TextStyle(
                        color: Colors.black
                      ),
                    )
                  ),
                  TextButton(
                    onPressed: () => true, 
                    child: Text(
                      "Height: ${this.newPet.height} cm",
                      style: TextStyle(
                        color: Colors.black
                      ),
                    )
                  ),
                  TextButton(
                    onPressed: () => true, 
                    child: Text(
                      "Weight: ${this.newPet.weight} kg",
                      style: TextStyle(
                        color: Colors.black
                      ),
                    )
                  ),
                  TextButton(
                    onPressed: () => true, 
                    child: Text(
                      "Age: ${this.newPet.age} years",
                      style: TextStyle(
                        color: Colors.black
                      ),
                    )
                  ),
                  TextButton(
                    onPressed: () => true, 
                    child: Text(
                      "Birthday: ${this.newPet.birthday} years",
                      style: TextStyle(
                        color: Colors.black
                      ),
                    )
                  ),
                ],
              ),
            ),
            Container(
              width: 85.0,
              child: TextButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.save,
                      color: Colors.black,
                    ),
                    Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.black
                      ),
                    )
                  ],
                ),
                onPressed: () => true,
              ),
            )
          ],
        ),
      ),
    );
  }

  inputStringDialog(BuildContext context, String title, attribute) {
    dialog(
      context,
    );
  }
}