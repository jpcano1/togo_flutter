import 'dart:async';

import 'package:app/src/bloc/blocs/bloc_base.dart';
import 'package:app/src/resources/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as Firestore;
import 'package:firebase_core/firebase_core.dart';

import '../../../models/store_vet.dart' as StoreVetModel;

class StoreVetListBloc extends BlocBase {
  Repository _repository = Repository();
  StreamController _storeVetListController = StreamController();

  Stream get storeVetListStream => _storeVetListController.stream;
  
  getList(bool store) async {
    try {
      List<Firestore.QueryDocumentSnapshot> result;
      List<StoreVetModel.StoreVet> vetStores = [];
      if (store) {
        result = await _repository.listStores();
      } else {
        result = await _repository.listVets();
      }

      for (Firestore.QueryDocumentSnapshot element in result) {
        vetStores.add(StoreVetModel.StoreVet.fromMap(element.data()));
      }

      if (store) {
        vetStores.sort((a, b) => b.locations.length.compareTo(a.locations.length));
      } else {
        vetStores.sort((a, b) => b.averageRating.compareTo(a.averageRating));
      }

      _storeVetListController.sink.add(vetStores);
    } on FirebaseException catch(e) {
      return Future.error(e.message);
    }
  }
  
  dispose() {
    _storeVetListController.close();
  }
}