import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

import '../../../models/pet.dart' as PetModel;
import '../../../resources/repository.dart';
import '../bloc_base.dart';

class ProfileBloc implements BlocBase {

  Repository _repository = Repository();
  StreamController<Map<String, dynamic>> _userProfileController = StreamController<Map<String, dynamic>>();
  StreamController<List<PetModel.Pet>> _petListController = StreamController<List<PetModel.Pet>>();

  Function(List<PetModel.Pet>) get petListAdd => _petListController.sink.add;
  Function(Map<String, dynamic>) get userAdd => _userProfileController.sink.add;

  Stream<List<PetModel.Pet>> get petListOut => _petListController.stream;
  Stream get userOut => _userProfileController.stream;

  Future<void> readUser() async {
    try {
      var uid = _repository.getCurrentUser().uid;
      var user = await _repository.readUser(uid: uid);
      userAdd(user.data());
      return;
    } on FirebaseException catch(e) {
      return Future.error(e.message);
    }
  }

  Future<void> listPets() async {
    List<PetModel.Pet> petList = [];
    var currentUser = _repository.getCurrentUser();
    try {
      var pets = await _repository.listPets(currentUser: currentUser);

      for (var pet in pets) {
        petList.add(PetModel.Pet.fromMap(pet.data()));
      }
      petListAdd(petList);
      return;
    } on FirebaseException catch(e) {
      return Future.error(e.message);
    } catch(e) {
      return Future.error(e.toString());
    }
  }

  dispose() {
    _userProfileController.close();
    _petListController.close();
  }
}