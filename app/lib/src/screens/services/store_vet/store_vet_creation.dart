import 'package:app/src/screens/services/store_vet/add_marker.dart';
import 'package:app/src/widgets/app_bar.dart';
import 'package:app/src/widgets/button.dart';
import 'package:flutter/material.dart';

class StoreVetCreationScreen extends StatefulWidget {
  final String vetId;

  StoreVetCreationScreen({this.vetId});
  @override
  _StoreVetCreationScreenState createState() => _StoreVetCreationScreenState();
}

class _StoreVetCreationScreenState extends State<StoreVetCreationScreen> {
  List<Map<String, double>> locations = [];
  Map<String, List<String>> officeHours = {};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
        backgroundColor: Colors.white, 
        iconColor: Colors.black
      ),
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              child: Text(
                "Register",
                style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.black
                ),
              ),
              margin: EdgeInsets.only(bottom: size.height * 0.05),
            ),
            Container(
              margin: EdgeInsets.only(bottom: size.height * 0.05),
              width: size.width * 0.8,
              child: AppButton(
                color: Theme.of(context).colorScheme.secondary, 
                onPressed: () async {
                  this.locations = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddMarkerScreen(
                        locations: this.locations,
                      )
                    )
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.gps_fixed,
                      color: Colors.black,
                    ),
                    Text(
                      "Pick Your Locations"
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: size.height * 0.05),
              width: size.width * 0.8,
              child: AppButton(
                color: Theme.of(context).colorScheme.secondary, 
                onPressed: () => true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                    Text(
                      "Pick Office Hours"
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: size.height * 0.05),
              width: size.width * 0.8,
              child: AppButton(
                color: Theme.of(context).colorScheme.secondary, 
                onPressed: () => true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.map,
                      color: Colors.black,
                    ),
                    Text(
                      "Upload Catalog"
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: size.height * 0.05),
              width: size.width * 0.8,
              child: AppButton(
                color: Theme.of(context).colorScheme.primary, 
                onPressed: () => true,
                text: "Next",
              ),
            )
          ],
        ),
      ),
    );
  }
}