import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';

import '../../../models/pet.dart' as PetModel;
import '../../../resources/repository.dart';
import '../bloc_base.dart';

class PetBloc implements BlocBase {

  Repository _repository = Repository();

  StreamController<List<PetModel.Pet>> _petListController = StreamController();
  StreamController<PetModel.Pet> _petDetailController = StreamController();

  Function(List<PetModel.Pet>) get petListAdd => _petListController.sink.add;
  Function(PetModel.Pet) get petDetailAdd => _petDetailController.sink.add;

  Stream<List<PetModel.Pet>> get petListOut => _petListController.stream;
  Stream<PetModel.Pet> get petDetailOut => _petDetailController.stream;

  Future<void> listPets(FirebaseAuth.User currentUser) async {
    List<PetModel.Pet> petList = [];
    try {
      var pets = await _repository.listPets(currentUser: currentUser);

      for (var pet in pets) {
        petList.add(PetModel.Pet.fromMap(pet.data()));
      }

      this.petListAdd(petList);
      return;
    } on FirebaseException catch(e) {
      return Future.error(e.message);
    } catch(e) {
      return Future.error(e.toString());
    }
  }

  Future<void> petDetail(String petId) async {
    try {
      var pet = await _repository.readPet(petId: petId);
      this.petDetailAdd(PetModel.Pet.fromMap(pet.data()));
      return;
    } on FirebaseException catch(e) {
      return Future.error(e.message);
    } catch(e) {
      return Future.error(e.toString());
    }
  }

  dispose() {
    _petListController.close();
    _petDetailController.close();
  }
}