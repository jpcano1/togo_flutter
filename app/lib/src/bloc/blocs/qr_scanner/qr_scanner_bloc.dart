import 'dart:async';

import 'package:app/src/bloc/blocs/bloc_base.dart';
import 'package:app/src/resources/repository.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../models/store_vet.dart' as StoreVetModel;

class QRScannerBloc extends BlocBase {
  
  Repository _repository = Repository();
  StreamController<StoreVetModel.StoreVet> _vetStoreController = StreamController<StoreVetModel.StoreVet>();

  Stream<StoreVetModel.StoreVet> get vetStoreOut => _vetStoreController.stream;

  Future readStoreVet(String storeVetId) async {
    try {
      var result = await _repository.readUser(
        uid: storeVetId
      );
      if (result.data() == null) {
        _vetStoreController.sink.addError("Not found!");
      }
      _vetStoreController.sink.add(StoreVetModel.StoreVet.fromMap(result.data()));
      return;
    } on FirebaseException catch(e) {
      throw Exception(e.message);
    } catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  void dispose() {
    _vetStoreController.close();
  }
}