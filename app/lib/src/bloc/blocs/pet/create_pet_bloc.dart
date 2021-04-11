import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/pet.dart' as PetModel;
import '../../../resources/repository.dart';
import '../validators.dart';
import '../bloc_base.dart';

class CreatePetBloc with Validators implements BlocBase {
  final _repository = Repository();
  
  BehaviorSubject<String> _nameController = BehaviorSubject<String>();
  BehaviorSubject<String> _breedController = BehaviorSubject<String>();
  BehaviorSubject<String> _heightController = BehaviorSubject<String>();
  BehaviorSubject<String> _weightController = BehaviorSubject<String>();
  BehaviorSubject<String> _ageController = BehaviorSubject<String>();
  BehaviorSubject<String> _birthdayController = BehaviorSubject<String>();
  StreamController<List<dynamic>> _pictureController = StreamController<List<dynamic>>();

  Stream<List<dynamic>> get pictureOut => _pictureController.stream;
  Stream<String> get nameOut => _nameController.stream.transform(validateEmptyField);
  Stream<String> get breedOut => _breedController.stream.transform(validateEmptyField);
  Stream<String> get heightOut => _heightController.stream.transform(validateNumberField);
  Stream<String> get weightOut => _weightController.stream.transform(validateNumberField);
  Stream<String> get ageOut => _ageController.stream.transform(validateNumberField);
  Stream<String> get birthdayOut => _birthdayController;
  Stream<bool> get petSubmit =>
    Rx.combineLatest6(
      nameOut, breedOut, heightOut,
      weightOut, ageOut, birthdayOut,
      (a, b, c, d, e, f) => true
    );

  Function(String) get nameChange => _nameController.sink.add;
  Function(String) get breedChange => _breedController.sink.add;
  Function(String) get heightChange => _heightController.sink.add;
  Function(String) get weightChange => _weightController.sink.add;
  Function(String) get ageChange => _ageController.sink.add;
  Function(String) get birthdayChange => _birthdayController.sink.add;
  Function(List<dynamic>) get pictureChange => _pictureController.sink.add;

  CreatePetBloc() {
    pictureOut
    .listen((List<dynamic> result) async {
      await uploadPicture(result[0], result[1]);
    });
  }

  Future<String> createPet() async {
    var currentUser = _repository.getCurrentUser();
    try {
      var pet = PetModel.Pet(
        _nameController.value, "", 
        _breedController.value, 
        double.tryParse(_heightController.value),
        double.tryParse(_weightController.value), 
        double.tryParse(_ageController.value).floor(),
        _birthdayController.value
      );

      String petId = await _repository.createPet(
        currentUser: currentUser,
        newPet: pet
      );

      return petId;
    } on FirebaseException catch(e) {
      return Future.error(e.message);
    } catch(e) {
      return Future.error(e.toString());
    }
  }

  Future<void> uploadPicture(File file, String petId) async {
    try {
      var format = file.path.split("/").last.split(".").last;
      String filename = petId + "." + format;
      var photoUrl = await _repository.uploadProfilePicture(
        filename: filename, 
        file: file, 
        directory: "pet_pictures"
      );

      await _repository.updatePet(
        petId: petId, 
        data: {
          "imagePath": photoUrl
        }
      );
    } on FirebaseException catch(e) {
      return Future.error(e.message);
    }
  }

  @override
  dispose() async {
    await _nameController.drain();
    _nameController.close();
    await _breedController.drain();
    _breedController.close();
    await _heightController.drain();
    _heightController.close();
    await _weightController.drain();
    _weightController.close();
    await _ageController.drain();
    _ageController.close();
    await _birthdayController.drain();
    _birthdayController.close();
    _pictureController.close();
  }
}