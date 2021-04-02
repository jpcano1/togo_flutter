import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../models/store_vet.dart';
import '../../../widgets/button.dart';
import '../../../widgets/app_bar.dart';
import '../../../utils/location.dart';
import '../../../utils/haversine.dart';

class StoreVetDetail extends StatefulWidget {
  final StoreVet storeVet;

  StoreVetDetail(this.storeVet, {Key key}): super(key: key);

  @override
  _StoreVetDetailState createState() => _StoreVetDetailState(this.storeVet);
}

class _StoreVetDetailState extends State<StoreVetDetail> {
  final StoreVet storeVet;
  final Set<Marker> markers = {};
  bool visible;
  BitmapDescriptor mapMarker;
  Position userLocation;
  double shortestDistance;

  _StoreVetDetailState(this.storeVet);

  @override
  initState() {
    super.initState();
    visible = false;
    initCustomMarker("assets/icons/pet-locator-2.png")
      .then((byteData) => mapMarker = BitmapDescriptor.fromBytes(byteData))
      .catchError(print);
  }

  String bestDistance(Position userLocation) {
    var shortestDistance = double.infinity;

    var currentUserCoordinates = {
      "lat": userLocation.latitude,
      "lng": userLocation.longitude
    };

    for (Map<String, double> location in this.storeVet.locations) {
      var startLat = currentUserCoordinates["lat"];
      var startLong = currentUserCoordinates["lng"];

      var endLat = location["lat"];
      var endLong = location["lng"];

      var distance = Haversine.distance(startLat, startLong, endLat, endLong);

      if (distance < shortestDistance) {
        shortestDistance = distance;
      }
    }
    return shortestDistance.toStringAsFixed(2);
  }

  Future<Uint8List> initCustomMarker(String path) async {
    try {
      ByteData byteData = await DefaultAssetBundle.of(context).load(path);
      return byteData.buffer.asUint8List();
    } catch(error) {
      throw new Exception(error);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      int counter = 1;
      for (Map<String, double> location in this.storeVet.locations) {
        markers.add(
          Marker(
            markerId: MarkerId("value-${counter++}"),
            position: LatLng(location["lat"], location["lng"]),
            infoWindow: InfoWindow(
              title: "Come Here!"
            ),
            icon: mapMarker
          )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final defaultVetImagePath = "assets/icons/snakes.png";

    AssetImage storeVetImage = AssetImage(
      this.storeVet.imagePath.isEmpty?
        defaultVetImagePath:
        this.storeVet.imagePath
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.background, 
        iconColor: Colors.black
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: size.height * 0.05),
                child: Column(
                  children: [
                    Text(
                      this.storeVet.name,
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.black
                      ),
                    ),
                    FutureBuilder(
                      future: determinePosition(),
                      builder: (futureContext, AsyncSnapshot<Position> snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            snapshot.error,
                            style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.black
                            ),
                          );
                        }
                        if (snapshot.hasData && 
                          snapshot.connectionState == ConnectionState.done) {
                          return Text(
                            "${bestDistance(snapshot.data)} km far from you",
                            style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.black
                            ),
                          );
                        }

                        return Text(
                          "Loading",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Colors.black
                          ),
                        );
                      },
                    ),
                  ],
                )
              ),
              CircleAvatar(
                backgroundImage: storeVetImage,
                backgroundColor: Theme.of(context).colorScheme.background,
                maxRadius: size.width * 0.2,
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.05),
                width: size.width,
                child: Column(
                  children: [
                    AppButton(
                      color: Theme.of(context).colorScheme.primary, 
                      text: "Office Hours", 
                      onPressed: () {
                        setState(() {
                          visible = !visible;
                        });
                      }
                    ),
                    Visibility(
                      visible: visible,
                      child: Column(
                        children: [
                          Container(
                            child: ListView(
                              children: List<Widget>.generate(
                                this.storeVet.officeHours.length, 
                                (int index) {
                                  String key = this.storeVet.officeHours.keys.elementAt(index);
                                  List<String> schedules = this.storeVet.officeHours[key];
                                  return Text(
                                    "$key: ${schedules[0]} - ${schedules[1]}",
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Theme.of(context).colorScheme.primary
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                }
                              ),
                            ),
                            height: this.storeVet.officeHours.length * 18.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: IconButton(
                              icon: Image.asset("assets/icons/chat-box.png"),
                              onPressed: () => true,
                            ),
                          )
                        ],
                      )
                    )
                  ],
                )
              ),
              Container(
                padding: EdgeInsets.all(size.width * 0.05),
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.grey,
                      width: 1.0
                    ),
                  )
                ),
                child: Row(
                  children: [
                    Container(
                      width: size.width * 0.7,
                      child: Text(
                        "Contact Us: ${this.storeVet.contactPhone}",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Theme.of(context).colorScheme.primary
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: size.width * 0.2,
                      child: IconButton(
                        icon: Image.asset(
                          "assets/icons/phone-call.png",
                          width: size.width * 0.09,
                        ),
                        onPressed: () => true,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: size.width * 0.6,
                      child: AppButton(
                        color: Theme.of(context).colorScheme.primary, 
                        text: "Download Catalog", 
                        onPressed: () => true,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: size.width * 0.3,
                      child: IconButton(
                        onPressed: () => true, 
                        icon: Image.asset(
                          "assets/icons/pdf.png",
                          width: size.width * 0.09,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Locations",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
              ),
              Container(
                child: GoogleMap(
                  onMapCreated: onMapCreated,
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      this.storeVet.locations[0]["lat"], 
                      this.storeVet.locations[0]["lng"]
                    ),
                    zoom: 14,
                  ),
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                  },
                ),
                height: size.height * 0.4,
                width: size.width,
              )
            ],
          ),
        ),
      )
    );
  }
}