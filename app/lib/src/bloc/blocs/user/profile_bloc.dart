import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';

import '../../../models/pet.dart' as PetModel;
import '../../../models/user.dart' as UserModel;
import '../../../resources/repository.dart';
import '../bloc_base.dart';

class ProfileBloc implements BlocBase {

  Repository _repository = Repository();
  StreamController<UserModel.User> _userProfileController = StreamController<UserModel.User>();
  StreamController<List<PetModel.Pet>> _petListController = StreamController();

  Function(List<PetModel.Pet>) get petListAdd => _petListController.sink.add;
  Function(UserModel.User) get userAdd => _userProfileController.sink.add;

  Stream<List<PetModel.Pet>> get petListOut => _petListController.stream;
  Stream<UserModel.User> get userOut => _userProfileController.stream;

  Future<void> readUser() async {
    try {
      var uid = _repository.getCurrentUser().uid;
      var user = await _repository.readUser(uid: uid);
      userAdd(UserModel.User.fromMap(user.data()));      
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
      this.petListAdd(petList);
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