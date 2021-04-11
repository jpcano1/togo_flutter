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
  BehaviorSubject<String> _heightController = BehaviorSubject<String>();
  BehaviorSubject<String> _weightController = BehaviorSubject<String>();
  BehaviorSubject<String> _ageController = BehaviorSubject<String>();
  BehaviorSubject<String> _birthdayController = BehaviorSubject<String>();

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

  createPet() async {
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

      var petId = await _repository.createPet(
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