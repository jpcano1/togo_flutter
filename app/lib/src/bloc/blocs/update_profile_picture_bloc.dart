import 'dart:async';
import 'dart:io';

import 'bloc_base.dart';
import '../../resources/repository.dart';

import 'package:firebase_storage/firebase_storage.dart' as FirebaseStorage;

class UpdateProfilePictureBloc implements BlocBase {
  final Repository _repository = Repository();
  final StreamController<List<dynamic>> _profileImageStream = StreamController<List<dynamic>>();

  Function(List<dynamic>) get profileImageChange => this._profileImageStream.sink.add;

  Stream<List<dynamic>> get profileImageOut => this._profileImageStream.stream;

  Future<String> upload(
    String filename, File file, 
    {directory="user_pictures/pet_owner"}
  ) async {
    String photoUrl;
    try {
      photoUrl = await _repository.uploadProfilePicture(
        filename: filename,
        file: file,
        directory: directory
      );
      await _repository.updateUser(
        uid: _repository.getCurrentUser().uid,
        data: {
          "imagePath": photoUrl
        }
      );
    } on FirebaseStorage.FirebaseException catch(_) {
      return Future.error("There was an error uploading the image");
    }
    return photoUrl;
  }

  @override
  dispose() {
    this._profileImageStream.close();
  }
}