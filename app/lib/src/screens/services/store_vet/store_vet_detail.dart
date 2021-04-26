import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../models/store_vet.dart';
import '../../../widgets/button.dart';
import '../../../widgets/app_bar.dart';
import '../../../utils/permissions.dart';
import '../../../utils/haversine.dart';
import '../../../utils/night_mode.dart';

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
  bool nightMode;
  BitmapDescriptor mapMarker;
  Position userLocation;
  double shortestDistance;
  Future<Position> position;
  String _mapStyle;

  _StoreVetDetailState(this.storeVet);

  @override
  initState() {
    super.initState();

    nightMode = isNightMode();
    visible = false;
    initCustomMarker("assets/icons/pet-locator-2.png")
      .then((byteData) => mapMarker = BitmapDescriptor.fromBytes(byteData))
      .catchError(print);
    this.position = determinePosition();

    if (nightMode) {
      rootBundle.loadString('assets/map_styles/night_mode.txt').then((string) {
        _mapStyle = string;
      });
    }
  }

  String bestDistance(Position userLocation) {
    var shortestDistance = double.infinity;

    var currentUserCoordinates = {
      "lat": userLocation.latitude,
      "lng": userLocation.longitude
    };

    for (Map location in this.storeVet.locations) {
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
    controller.setMapStyle(this._mapStyle);
    setState(() {
      int counter = 1;
      for (Map location in this.storeVet.locations) {
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

    var storeVetImage;

    if (storeVet.imagePath.isNotEmpty) {
      storeVetImage = NetworkImage(storeVet.imagePath);
    } else {
      storeVetImage = AssetImage(defaultVetImagePath);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.background, 
        iconColor: nightMode? Colors.white: Colors.black
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
                        color: nightMode? Colors.white: Colors.black
                      ),
                    ),
                    FutureBuilder(
                      future: this.position,
                      builder: (futureContext, AsyncSnapshot<Position> snapshot) {
                        var message;
                        if (snapshot.hasError) {
                          message = snapshot.error;
                        } else if (snapshot.hasData && 
                          snapshot.connectionState == ConnectionState.done) {
                          message = "${bestDistance(snapshot.data)} km far from you";
                        } else {
                          message = "Loading";
                        }
                        return Text(
                          message,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: nightMode? Colors.white: Colors.black
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
                margin: EdgeInsets.all(size.width * 0.05),
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Office Hours:",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Theme.of(context).colorScheme.primary
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: ListView(
                              children: List<Widget>.generate(
                                this.storeVet.officeHours.length, 
                                (int index) {
                                  String key = this.storeVet.officeHours.keys.elementAt(index);
                                  List schedules = this.storeVet.officeHours[key];
                                  return Text(
                                    "$key: ${schedules[0]} - ${schedules[1]}",
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Theme.of(context).colorScheme.primary
                                    ),
                                    textAlign: TextAlign.start,
                                  );
                                }
                              ),
                            ),
                            width: size.width * 0.7,
                            height: this.storeVet.officeHours.length * 20.0,
                          ),
                          Container(
                            width: size.width * 0.2,
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Image.asset(
                                "assets/icons/chat-box.png",
                                width: size.width * 0.09,
                              ),
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
                        "Contact Us: ${this.storeVet.phoneNumber}",
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