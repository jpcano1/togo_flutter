import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/user/store_vet_list_bloc.dart';
import 'package:app/src/screens/services/store_vet/store_vet_list.dart';

import '../../widgets/button.dart';
import 'package:flutter/material.dart';
import '../../utils/night_mode.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class ServicesScreen extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  ServicesScreen({this.analytics, this.observer});

  Future <void> _setCurrentScreen() async{
    await analytics.setCurrentScreen(screenName: "Services View");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool nightMode = isNightMode();
    _setCurrentScreen();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: nightMode? Colors.white: Colors.black
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
                  color: nightMode? Colors.white: Colors.black,
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
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Provider(
                          bloc: StoreVetListBloc(),
                          child: StoreVetListScreen(stores: false),
                        )
                      )
                    ),
                    minWidth: size.width * 0.35,
                  ),
                  Padding(padding: EdgeInsets.all(size.width * 0.08)),
                  AppButton(
                    color: Theme.of(context).colorScheme.primary, 
                    text: "Stores", 
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Provider(
                          bloc: StoreVetListBloc(),
                          child: StoreVetListScreen(stores: true),
                        )
                      )
                    ),
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