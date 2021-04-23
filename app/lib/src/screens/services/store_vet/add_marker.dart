import 'package:app/src/utils/permissions.dart';
import 'package:app/src/widgets/app_bar.dart';
import 'package:app/src/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddMarkerScreen extends StatefulWidget {
  final List<Map<String, double>> locations; 

  AddMarkerScreen({this.locations});

  @override
  _AddMarkerScreenState createState() => _AddMarkerScreenState();
}

class _AddMarkerScreenState extends State<AddMarkerScreen> {
  Set<Marker> markers = {};
  Map<String, Map<String, double>> locations;
  Position userLocation;
  Future<Position> position;

  @override
  void initState() {
    super.initState();
    position = determinePosition();

    this.locations = <String, Map<String, double>>{};

    if (widget.locations != null && widget.locations.isNotEmpty) {
      widget.locations.forEach((element) {
        var markerId = MarkerId("${this.markers.length}");
        this.locations[markerId.value] = element;
        this.markers.add(
          Marker(
            markerId: markerId,
            draggable: true,
            position: LatLng(
              element["lat"],
              element["lng"]
            ),
            onDragEnd: (LatLng newPosition) {
              updatePosition(markerId, newPosition);
            },
            onTap: () => deleteMarker(markerId)
          )
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.primaryVariant, 
        iconColor: Colors.white
      ),
      body: Container(
        child: FutureBuilder(
          future: this.position,
          builder: (_, AsyncSnapshot<Position> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    snapshot.data.latitude,
                    snapshot.data.longitude
                  ),
                  zoom: 14,
                ),
                onTap: (LatLng newPosition) {
                  var markerId = MarkerId("${this.markers.length}");
                  setState(() {
                    this.locations[markerId.value] = {
                      "lat": newPosition.latitude,
                      "lng": newPosition.longitude
                    };
                    this.markers.add(
                      Marker(
                        markerId: markerId,
                        draggable: true,
                        position: newPosition,
                        onDragEnd: (LatLng newPosition) {
                          updatePosition(markerId, newPosition);
                        },
                        onTap: () => deleteMarker(markerId)
                      )
                    );
                  });
                  return;
                },
                markers: this.markers,
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error),
              );
            }
            return Center(
              child: LoadingSpinner(),
            );
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () => Navigator.pop(context, this.locations.values.toList())
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  deleteMarker(MarkerId id) {
    setState(() {
      this.markers.removeWhere((item) => item.markerId == id);
      this.locations.remove(id.value);
    });
  }

  updatePosition(MarkerId id, LatLng newPosition) {
    setState(() {
      this.locations[id.value] = {
        "lat": newPosition.latitude,
        "lng": newPosition.longitude
      };
    });
  }
}