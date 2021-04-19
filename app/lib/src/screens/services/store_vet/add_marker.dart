import 'package:app/src/utils/permissions.dart';
import 'package:app/src/widgets/app_bar.dart';
import 'package:app/src/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddMarkerScreen extends StatefulWidget {
  @override
  _AddMarkerScreenState createState() => _AddMarkerScreenState();
}

class _AddMarkerScreenState extends State<AddMarkerScreen> {
  final Set<Marker> markers = {};
  Position userLocation;
  Future<Position> position;

  @override
  void initState() {
    super.initState();
    position = determinePosition();
  }

  void onMapCreated(GoogleMapController controller) {

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
              setState(() {
                this.userLocation = snapshot.data;
              });
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    this.userLocation.latitude,
                    this.userLocation.longitude
                  ),
                  zoom: 14
                ),
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
        child: Icon(Icons.add),
        onPressed: () {
          var markerId = MarkerId("${this.markers.length}");
          setState(() {
            this.markers.add(
              Marker(
                markerId: markerId,
                draggable: true,
                position: LatLng(
                  this.userLocation.latitude,
                  this.userLocation.longitude
                ),
                onTap: () => deleteMarker(markerId)
              )
            );
          });
        },
      ),
    );
  }

  deleteMarker(MarkerId id) {
    this.markers.removeWhere((item) => item.markerId == id);
  }
}