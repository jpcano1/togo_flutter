import 'dart:async';

import '../../../models/pet.dart' as PetModel;
import '../../../models/user.dart' as UserModel;
import '../../../resources/repository.dart';
import '../validators.dart';
import '../bloc_base.dart';

class CreatePetBloc with Validators implements BlocBase {
  final _repository = Repository();
  
  StreamController _nameController = StreamController();
  
  Stream<String> get nameOut => _nameController.stream.transform(validateEmptyField);

  Function(String) get nameChange => _nameController.sink.add;
  
  createPet(UserModel.User currentUser, PetModel.Pet newPet) async {
    await _repository.createPet(
      currentUser: currentUser,
      newPet: newPet
    );
  }

  @override
  dispose() {
    _nameController.close();
  }
}