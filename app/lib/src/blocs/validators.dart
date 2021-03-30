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
      Pattern pattern = r"^[a-zA-Z]\w{5,14}$";
      RegExp regex = RegExp(pattern);
      if (password.isEmpty) {
        sink.addError("Password cannot be empty");
      } else if (!regex.hasMatch(password)) {
        sink.addError("Password not valid. Must be between 6 and 14 characters and have letters and numbers");
      } else {
        sink.add(password);
      }
    }
  );

  final validateLoginField = StreamTransformer<String, String>.fromHandlers(
    handleData: (String fieldData, EventSink sink) {
      if (fieldData.isEmpty) {
        sink.addError("Field cannot be empty");
      } else {
        sink.add(fieldData);
      }
    }
  );
}