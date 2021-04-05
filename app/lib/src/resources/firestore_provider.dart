import 'package:cloud_firestore/cloud_firestore.dart' as Firestore;
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
    return await database.collection(userCollection).doc(currentUser.id).set(currentUser.toMap());
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
  Future<void> createPet(
    {UserModel.User currentUser, PetModel.Pet newPet}
  ) async {
    Firestore.DocumentReference petDocument = await database.collection(petCollection).add({
      ...newPet.toMap(),
      "ownerId": currentUser.id
    });
    return await database.collection(userCollection).doc(currentUser.id).set({
      "pets": [...currentUser.pets, petDocument.id]
    });
  }
}