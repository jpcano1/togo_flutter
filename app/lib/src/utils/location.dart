import 'package:geolocator/geolocator.dart';

Future<Position> deteriminePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error(
      "Location services are disabled"
    );
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        "Location permissions are permanently denied, we cannot request permissions."
      );
    }
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error(
        'Location permissions are denied'
      );
    }
  }

  return Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best
  );
}