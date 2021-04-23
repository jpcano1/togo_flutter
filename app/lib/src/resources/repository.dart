import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:cloud_firestore/cloud_firestore.dart' as Firestore;
import 'package:flutter/foundation.dart';

import '../models/user.dart' as UserModel;
import '../models/pet.dart' as PetModel;

import 'firebase_auth_provider.dart' as AuthProvider;
import 'firebase_storage_provider.dart' as StorageProvider;
import 'firestore_provider.dart' as FirestoreProvider;

class Repository {
  final _authProvider = AuthProvider.FirebaseAuthProvider();
  final _storageProvider = StorageProvider.FirebaseStorageProvider();
  final _firestoreProvider = FirestoreProvider.FirestoreProvider();

  Repository() {
    _authProvider.openAuthenticator();
    _storageProvider.openStorage();
    _firestoreProvider.openDatabase();
  }

  // Auth Functions
  Future<FirebaseAuth.UserCredential> login({
    @required String email, 
    @required String password
  }) =>
    _authProvider.login(email: email, password: password);

  Future<FirebaseAuth.UserCredential> register({
    @required String email, 
    @required String password
  }) =>
    _authProvider.register(email: email, password: password);
  
  Future<void> updateUserData({@required Map<String, String> data}) =>
    _authProvider.updateUserData(data: data);

  Future<void> verifyEmail() =>
    _authProvider.verifyEmail();
  
  FirebaseAuth.User getCurrentUser() => 
    _authProvider.getCurrentUser();

  // Storage Functions
  Future<String> uploadProfilePicture({
    @required String filename, 
    @required File file,
    @required directory
  }) =>
    _storageProvider.uploadProfilePicture(
      filename: filename, 
      file: file,
      directory: directory
    );

  // Firestore Functions
  // User Operations
  Future<void> createUser({@required UserModel.User currentUser}) => 
    _firestoreProvider.createUser(currentUser: currentUser);
  
  Future<Firestore.DocumentSnapshot> readUser({@required String uid}) =>
    _firestoreProvider.readUser(uid: uid);
  
  Future<void> updateUser({
    @required String uid, 
    @required Map<String, dynamic> data
  }) =>
    _firestoreProvider.updateUser(uid: uid, data: data);
  
  Future<void> deleteUser({
    @required String uid
  }) =>
    _firestoreProvider.deleteUser(uid: uid);

  // Pet Operations
  Future<String> createPet({
    @required FirebaseAuth.User currentUser, 
    @required PetModel.Pet newPet
  }) => 
    _firestoreProvider.createPet(currentUser: currentUser, newPet: newPet);

  Future<void> updatePet({
    @required String petId, 
    @required Map<String, dynamic> data
  }) => 
    _firestoreProvider.updatePet(petId: petId, data: data);
  
  Future<Firestore.DocumentSnapshot> readPet({@required String petId}) =>
    _firestoreProvider.readPet(petId: petId);
  
  Future<void> deletePet({@required String petId}) =>
    _firestoreProvider.deletePet(petId: petId);
  
  Future<List<Firestore.QueryDocumentSnapshot>> listPets(
    {@required FirebaseAuth.User currentUser}
  ) => 
    _firestoreProvider.listPets(currentUser: currentUser);
  
  // StoreVet Operations
  Future<void> createStoreVet({@required storeVet}) => 
    _firestoreProvider.createStoreVet(storeVet);
}