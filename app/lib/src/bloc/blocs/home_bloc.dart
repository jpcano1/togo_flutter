import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO check if useful
class HomeBloc extends Bloc {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String getUserName() {
    String username = "";

    _getUserName() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      username = prefs.getString('logName');
    }

    return username;
  }

  @override
  dispose() {}
}
