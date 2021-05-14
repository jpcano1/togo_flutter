//TODO delete or uncomment code if necessary
// class PreferenceBloc {
//   final _emailController = StreamController<String>();
//   final _nameController = StreamController<String>();
//   final _phoneController = StreamController<String>();
//
//   //Getters
//   Stream<String> get email => _emailController.stream;
//   Stream<String> get name => _nameController.stream;
//   Stream<String> get phone => _phoneController.stream;
//
//   //Setters
//   Function(String) get saveEmail => _emailController.sink.add;
//   Function(String) get saveName => _nameController.sink.add;
//   Function(String) get savePhone => _phoneController.sink.add;
//
//   saveCredentials() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//   }
// }
