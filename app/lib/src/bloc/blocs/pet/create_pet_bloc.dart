import 'dart:async';
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
  BehaviorSubject _heightController = BehaviorSubject();
  BehaviorSubject _weightController = BehaviorSubject();
  BehaviorSubject _ageController = BehaviorSubject();
  BehaviorSubject<String> _birthdayController = BehaviorSubject<String>();

  Stream<String> get nameOut => _nameController.stream.transform(validateEmptyField);
  Stream<String> get breedOut => _breedController.stream.transform(validateEmptyField);
  Stream get heightOut => _heightController.stream.transform(validateNumberField);
  Stream get weightOut => _weightController.stream.transform(validateNumberField);
  Stream get ageOut => _ageController.stream.transform(validateNumberField);
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

  createPet() async {
    var currentUser = _repository.getCurrentUser();
    try {
      var pet = PetModel.Pet(
        _nameController.value, "", 
        _breedController.value, _heightController.value,
        _weightController.value, _ageController.value,
        _birthdayController.value
      );

      var petId = _repository.createPet(
        currentUser: currentUser,
        newPet: pet
      );

      List<Map<String, dynamic>> userPets = (
        await _repository.readUser(uid: currentUser.uid)
      ).data()["pets"];

      userPets.add({
        "id": petId,
        "imagePath": pet.imagePath,
        "name": pet.name
      });

      await _repository.updateUser(
        uid: currentUser.uid, 
        data: {
          "pets": userPets
        }
      );
    } on FirebaseException catch(e) {
      return Future.error(e.message);
    } catch(e) {
      return Future.error(e.toString());
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
  }
}