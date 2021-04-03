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

  
}