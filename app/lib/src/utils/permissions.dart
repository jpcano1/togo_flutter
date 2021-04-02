import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File> uploadImage() async {
  final picker = ImagePicker();
  PickedFile image;

  PermissionStatus result = await Permission.storage.status;

  if (result.isDenied || result.isRestricted) {
    result = await Permission.storage.request();
    if (result.isPermanentlyDenied) {
      return Future.error(
        "Photo permissions are permanently denied, we cannot request permissions."
      );
    }
    if (result.isDenied) {
      return Future.error(
        "Photo permissions are denied"
      );
    }
  }

  image = await picker.getImage(source: ImageSource.gallery);

  if (image != null) {
    return File(image.path);
  } else {
    return Future.error(
      "No image selected"
    );
  }
}

Future<Position> determinePosition() async {
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

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best
  );
}

Future<String> cameraPermission() async {
  PermissionStatus result = await Permission.camera.status;

  if (result.isDenied || result.isRestricted) {
    result = await Permission.camera.request();
    if (result.isPermanentlyDenied) {
      return Future.error(
        "Camera permissions are permanently denied, we cannot request permissions."
      );
    }
    if (result.isDenied) {
      return Future.error(
        "Camera permissions are denied"
      );
    }
  }

  return "Permissions granted";
}