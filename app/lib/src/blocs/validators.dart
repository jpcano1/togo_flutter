import 'dart:async';

class Validators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (String email, EventSink sink) {
      Pattern pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
      RegExp regex = RegExp(pattern);
      if (regex.hasMatch(email)) {
        sink.add(email);
      } else if (email.isEmpty) {
        sink.addError("Email cannot be empty");
      } else {
        sink.addError("Email not valid");
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (String password, EventSink sink) {
      Pattern pattern = r"^[a-zA-Z]\w{3,14}$";
      RegExp regex = RegExp(pattern);
      if (password.isEmpty) {
        sink.addError("Password cannot be empty");
      } else if (!regex.hasMatch(password)) {
        sink.addError("Password not strong enough");
      } else {
        sink.add(password);
      }
    }
  );
}