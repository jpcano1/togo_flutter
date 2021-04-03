import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class FirebaseAuthProvider {
  static final FirebaseAuthProvider firebaseAuthProvider = FirebaseAuthProvider._internal();

  FirebaseAuthProvider._internal();

  factory FirebaseAuthProvider() {
    return firebaseAuthProvider;
  }

  FirebaseAuth.FirebaseAuth authenticator;

  FirebaseAuth.FirebaseAuth openAuthenticator() {
    if (this.authenticator == null) {
      authenticator = FirebaseAuth.FirebaseAuth.instance;
    }
    return authenticator;
  }

  Future<FirebaseAuth.UserCredential> login({
    String email, 
    String password
  }) async {
    return await authenticator.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  Future<FirebaseAuth.UserCredential> register({
    String email, 
    String password
  }) async {
    return await authenticator.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  Future<void> updateUserData({Map<String, String> data}) async {
    return await authenticator.currentUser.updateProfile(
      displayName: data["displayName"]?? "",
      photoURL: data["photoUrl"]?? ""
    );
  }

  Future<void> verifyEmail() async {
    return await authenticator.currentUser.sendEmailVerification();
  }
}