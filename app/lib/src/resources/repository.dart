import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:cloud_firestore/cloud_firestore.dart' as Firestore;

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
  Future<FirebaseAuth.UserCredential> login({String email, String password}) =>
    _authProvider.login(email: email, password: password);

  Future<FirebaseAuth.UserCredential> register({String email, String password}) =>
    _authProvider.register(email: email, password: password);
  
  Future<void> updateUserData({Map<String, String> data}) =>
    _authProvider.updateUserData(data: data);

  Future<void> verifyEmail() =>
    _authProvider.verifyEmail();
  
  FirebaseAuth.User getCurrentUser() => 
    _authProvider.getCurrentUser();

  // Storage Functions
  Future<String> uploadProfilePicture({String filename, File file}) =>
    _storageProvider.uploadProfilePicture(filename: filename, file: file);

  // Firestore Functions
  // User Operations
  Future<void> createUser({UserModel.User currentUser}) => 
    _firestoreProvider.createUser(currentUser: currentUser);
  
  Future<Firestore.DocumentSnapshot> readUser({String uid}) =>
    _firestoreProvider.readUser(uid: uid);
  
  Future<void> updateUser({String uid, Map<String, dynamic> data}) =>
    _firestoreProvider.updateUser(uid: uid, data: data);
  
  Future<void> deleteUser({String uid}) =>
    _firestoreProvider.deleteUser(uid: uid);

  // Pet Operations
  Future<void> createPet({UserModel.User currentUser, PetModel.Pet newPet}) => 
    _firestoreProvider.createPet(currentUser: currentUser, newPet: newPet);
}