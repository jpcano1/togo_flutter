import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as FirebaseStorage;

class FirebaseStorageProvider {
  static final FirebaseStorageProvider firebaseStorageProvider = FirebaseStorageProvider._internal();

  FirebaseStorageProvider._internal();

  factory FirebaseStorageProvider() {
    return firebaseStorageProvider;
  }

  FirebaseStorage.FirebaseStorage storage;

  FirebaseStorage.FirebaseStorage openStorage() {
    if (storage == null) {
      storage = FirebaseStorage.FirebaseStorage.instance;
    }
    return storage;
  }

  // User actions
  Future<String> uploadProfilePicture({String filename, File file}) async {
    var snapshot = await storage
    .ref()
    .child("user_pictures/pet_owner/$filename")
    .putFile(file);
    return await snapshot.ref.getDownloadURL();
  }
}