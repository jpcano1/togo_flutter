import 'package:app/src/bloc/blocs/bloc_base.dart';
import 'package:app/src/resources/repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rxdart/rxdart.dart';

class StoreVetCreationBloc extends BlocBase {
  final Repository _repository = Repository();
  final _locationsController = BehaviorSubject();
  final _officeHoursController = BehaviorSubject();
  final _roleController = BehaviorSubject();

  Function get locationsChange => _locationsController.sink.add;
  Function get officeHoursChange => _officeHoursController.sink.add;
  Function get roleChange => _roleController.sink.add;
  
  Future<void> submit() async {
    var newData = {
      "locations": _locationsController.value,
      "officeHours": _officeHoursController.value,
      "petOwner": false,
      "store": _roleController.value?? false,
      "vet": !_roleController.value?? true,
      "catalog": ""
    };

    try {
      _repository.updateUser(
        uid: _repository.getCurrentUser().uid, 
        data: newData
      );
    } on FirebaseException catch(e) {
      return Future.error(e.message);
    } catch(e) {
      return Future.error(e.toString());
    }
  }

  dispose() async {
    await _locationsController.drain();
    _locationsController.close();
    await _officeHoursController.drain();
    _officeHoursController.drain();
    await _roleController.drain();
    _roleController.close();
  }
}