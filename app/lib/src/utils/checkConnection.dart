import 'package:connectivity/connectivity.dart';

Future<bool> checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return Future<bool>.value(true);
  } else {
    return Future<bool>.value(false);
  }
}
