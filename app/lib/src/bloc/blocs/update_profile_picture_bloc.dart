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

  Future<String> upload(String filename, File file) async {
    String photoUrl;
    try {
      photoUrl = await _repository.uploadProfilePicture(
        filename: filename,
        file: file
      );
    } on FirebaseStorage.FirebaseException catch(e) {
      return Future.error("There was an error uploading the image");
    }
    return photoUrl;
  }

  @override
  dispose() {
    this._profileImageStream.close();
  }
}