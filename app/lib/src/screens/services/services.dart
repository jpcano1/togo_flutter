import 'package:app/src/widgets/button.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: size.width,
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Services",
                style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/veterinary.png",
                    width: size.width * 0.4,
                  ),
                  Padding(padding: EdgeInsets.all(size.width * 0.05)),
                  Image.asset(
                    "assets/icons/pet-shop-logo.png",
                    width: size.width * 0.4,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    color: Theme.of(context).colorScheme.primary, 
                    text: "Vets", 
                    onPressed: () => true,
                    minWidth: size.width * 0.35,
                  ),
                  Padding(padding: EdgeInsets.all(size.width * 0.08)),
                  AppButton(
                    color: Theme.of(context).colorScheme.primary, 
                    text: "Stores", 
                    onPressed: () => true,
                    minWidth: size.width * 0.35,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/dog.png",
                    width: size.width * 0.4,
                  ),
                  Padding(padding: EdgeInsets.all(size.width * 0.05)),
                  Image.asset(
                    "assets/icons/dog-house-2.png",
                    width: size.width * 0.4,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    color: Theme.of(context).colorScheme.primary, 
                    text: "Walkers", 
                    onPressed: () => true,
                    minWidth: size.width * 0.35,
                  ),
                  Padding(padding: EdgeInsets.all(size.width * 0.08)),
                  AppButton(
                    color: Theme.of(context).colorScheme.primary, 
                    text: "Daycare", 
                    onPressed: () => true,
                    minWidth: size.width * 0.35,
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