import 'dart:io';

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