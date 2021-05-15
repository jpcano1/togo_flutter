import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/user/store_vet_list_bloc.dart';
import 'package:app/src/utils/checkConnection.dart';
import 'package:app/src/widgets/spinner.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../models/store_vet.dart' as StoreVetModel;
import '../../../utils/night_mode.dart';
import '../../../widgets/app_bar.dart';
import 'store_vet_detail.dart';

class StoreVetListScreen extends StatelessWidget {
  final stores;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  StoreVetListScreen({this.stores = false, this.analytics, this.observer});

  Future <void> _setCurrentScreenStores() async{
    await analytics.setCurrentScreen(screenName: "StoreListView");
  }

  Future <void> _setCurrentScreenVets() async{
    await analytics.setCurrentScreen(screenName: "VetListView");
  }

  Future <void> _sendEventVets() async{
    await analytics.logEvent(name: "vet_list_screen", parameters: null);
  }

  Future <void> _sendEventStores() async{
    await analytics.logEvent(name: "store_list_screen", parameters: null);
  }

  @override
  Widget build(BuildContext context) {
    bool nightMode = isNightMode();
    final size = MediaQuery.of(context).size;
    final bloc = Provider.of<StoreVetListBloc>(context);
    this.stores? _setCurrentScreenStores():_setCurrentScreenVets();
    this.stores? _sendEventStores():_sendEventVets();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          iconColor: nightMode ? Colors.white : Colors.black),
      body: Container(
        child: Column(
          children: [
            Container(
              width: size.width,
              margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
              padding: EdgeInsets.only(left: size.width * 0.05),
              child: Text(
                this.stores ? "Stores" : "Vets",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: nightMode ? Colors.white : Colors.black),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: FutureBuilder(
                future: bloc.getList(this.stores),
                builder: (_, futureSnapshot) {
                  if (futureSnapshot.connectionState == ConnectionState.done) {
                    return StreamBuilder(
                        stream: bloc.storeVetListStream,
                        builder: (_, streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return buildStoreVetList(
                                context, size, nightMode, streamSnapshot.data);
                          }
                          if (streamSnapshot.hasError) {
                            return Center(child: Text(streamSnapshot.error));
                          }
                          return Center(
                            child: LoadingSpinner(),
                          );
                        });
                  }
                  if (futureSnapshot.hasError) {
                    return Center(child: Text(futureSnapshot.error));
                  }
                  return Center(
                    child: LoadingSpinner(),
                  );
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  buildStoreVetList(
      BuildContext context, Size size, bool nightMode, List vetList) {
    final defaultVetImagePath = "assets/icons/snakes.png";
    return ListView.builder(
      itemCount: vetList.length,
      itemBuilder: (BuildContext listContext, int index) {
        StoreVetModel.StoreVet storeVet = vetList[index];
        var image;

        if (storeVet.imagePath.isNotEmpty) {
          image = NetworkImage(storeVet.imagePath);
        } else {
          image = AssetImage(defaultVetImagePath);
        }

        return Card(
          color: nightMode ? Colors.black : Colors.white,
          shadowColor: nightMode ? Colors.white : Colors.black,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: image,
              backgroundColor: Colors.white,
              maxRadius: size.height * 0.03,
            ),
            onTap: () {
              checkConnectivity().then((connected) {
                if (connected) {
                  Navigator.push(
                      listContext,
                      MaterialPageRoute(
                          builder: (_) => StoreVetDetail(storeVet, analytics, observer)));
                } else {
                  _noConnectionDialog(context);
                }
              });
            },
            title: Text(
              storeVet.name,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: nightMode ? Colors.white : Colors.black),
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                ),
                Text(
                  storeVet.averageRating.toStringAsFixed(1),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: nightMode ? Colors.white : Colors.black),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //TODO check reused code
  _noConnectionDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "No internet connection",
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You don\'t have an internet connection, try again later.',
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.black,
              ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }
}
