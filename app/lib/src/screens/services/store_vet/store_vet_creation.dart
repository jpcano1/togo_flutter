import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/update_profile_picture_bloc.dart';
import 'package:app/src/bloc/blocs/user/store_vet_creation_bloc.dart';
import 'package:app/src/screens/services/store_vet/add_marker.dart';
import 'package:app/src/screens/services/store_vet/add_office_hours.dart';
import 'package:app/src/screens/user/profile_picture_upload.dart';
import 'package:app/src/utils/notification_dialog.dart';
import 'package:app/src/widgets/app_bar.dart';
import 'package:app/src/widgets/button.dart';
import 'package:app/src/widgets/spinner.dart';
import 'package:app/src/widgets/toast_alert.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class StoreVetCreationScreen extends StatefulWidget {
  final String vetId;

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  StoreVetCreationScreen({this.vetId, this.analytics, this.observer});
  @override
  _StoreVetCreationScreenState createState() => _StoreVetCreationScreenState();
}

class _StoreVetCreationScreenState extends State<StoreVetCreationScreen> {
  List<Map<String, double>> locations = [];
  Map<String, List<String>> officeHours = {};

  bool storeRole = false;

  Future <void> _setCurrentScreen() async{
    await widget.analytics.setCurrentScreen(screenName: "ServiceCreation");
  }

  Future<void> _logService() async{
    await widget.analytics.logEvent(name: "service_register", parameters: {'Store': this.storeRole});
  }


  @override
  Widget build(BuildContext context) {
    _setCurrentScreen();
    final size = MediaQuery.of(context).size;
    final bloc = Provider.of<StoreVetCreationBloc>(context);
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
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddMarkerScreen(
                        locations: this.locations,
                      )
                    )
                  );
                  setState(() {
                    if (result != null) {
                      this.locations = result;
                    }
                  });
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
                onPressed: () async {
                  var result = await Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_) => AddOfficeHoursScreen(
                        officeHours: this.officeHours,
                      )
                    )
                  );
                  setState(() {
                    if (result != null) {
                      this.officeHours = result;
                    }
                  });
                },
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
              child: Row(
                children: [
                  Text(
                    "Are you a store provider?",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                  Checkbox(
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (bool value) {
                      setState(() {
                        this.storeRole = value;  
                      });
                    },
                    value: this.storeRole,
                  ),
                ],
              )
            ),
            Container(
              margin: EdgeInsets.only(bottom: size.height * 0.05),
              width: size.width * 0.8,
              child: AppButton(
                color: Theme.of(context).colorScheme.primary, 
                onPressed: () async {
                  _logService();
                  bloc.roleChange(storeRole);
                  bloc.locationsChange(locations);
                  bloc.officeHoursChange(officeHours);
                  dialog(context, content: LoadingSpinner());
                  String userId;
                  try {
                    userId = await bloc.submit();
                  } catch(e) {
                    Navigator.pop(context);
                    showToast(e, context);
                    return;
                  }
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (_) => Provider(
                        bloc: UpdateProfilePictureBloc(), 
                        child: ProfilePictureUploadScreen(
                          userId, directory: 
                          "user_pictures/store_vet"
                        )
                      )
                    )
                  );
                },
                text: "Next",
              ),
            )
          ],
        ),
      ),
    );
  }
}