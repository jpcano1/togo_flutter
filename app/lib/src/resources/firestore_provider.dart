import 'package:cloud_firestore/cloud_firestore.dart' as Firestore;
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import '../models/user.dart' as UserModel;
import '../models/pet.dart' as PetModel;

class FirestoreProvider {
  static final FirestoreProvider firestoreProvider = FirestoreProvider._internal();

  final String userCollection = "User";
  final String petCollection = "Pet";

  FirestoreProvider._internal();

  factory FirestoreProvider() {
    return firestoreProvider;
  }

  Firestore.FirebaseFirestore database;

  Firestore.FirebaseFirestore openDatabase() {
    if (this.database == null) {
      database = Firestore.FirebaseFirestore.instance;
    }
    return database;
  }

  // User Functions
  // Create, get, update, delete
  Future<void> createUser({UserModel.User currentUser}) async {
    return await database.collection(userCollection).doc(currentUser.id)
    .set(currentUser.toMap());
  }

  Future<Firestore.DocumentSnapshot> readUser({String uid}) async {
    return await database.collection(userCollection).doc(uid).get();
  }

  Future<void> updateUser({String uid, Map<String, dynamic> data}) async {
    return await database.collection(userCollection).doc(uid).update(data);
  }

  Future<void> deleteUser({String uid}) async {
    return await database.collection(userCollection).doc(uid).delete();
  }

  // Pet Functions
  // Create, get, update, delete
  Future<String> createPet(
    {FirebaseAuth.User currentUser, PetModel.Pet newPet}
  ) async {
    Firestore.DocumentReference petDocument = await database.collection(petCollection).add({
      ...newPet.toMap(),
      "ownerId": currentUser.uid
    });
    return petDocument.id;
  }

  Future<List<Firestore.QueryDocumentSnapshot>> listPets(
    {FirebaseAuth.User currentUser}
  ) async {
    Firestore.QuerySnapshot petListDocument = await database.collection(petCollection)
    .where("ownerId", isEqualTo: currentUser.uid)
    .get();
    return petListDocument.docs;
  }

  Future<void> updatePet({
    String petId, Map<String, dynamic> data
  }) async {
    return await database.collection(petCollection).doc(petId).update(data);
  }

  Future<Firestore.DocumentSnapshot> readPet({String petId}) async {
    return await database.collection(petCollection).doc(petId).get();
  }

  Future<void> deletePet({String petId}) async {
    return await database.collection(petCollection).doc(petId).delete();
  }
}