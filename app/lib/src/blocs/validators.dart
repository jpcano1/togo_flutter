import 'dart:async';

class Validators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (String email, EventSink sink) {
      Pattern pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
      RegExp regex = RegExp(pattern);
      if (regex.hasMatch(email)) {
        sink.add(email);
      } else if (email.isEmpty) {
        sink.addError("El email no puede estar vacío");
      } else {
        sink.addError("El email no tiene un formato válido");
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (String password, EventSink sink) {
      Pattern pattern = r"^[a-zA-Z]\w{3,14}$";
      RegExp regex = RegExp(pattern);
      if (password.isEmpty) {
        sink.addError("El Password no puede estar vacío");
      } else if (!regex.hasMatch(password)) {
        sink.addError("El Password debe tener al menos 4 caracteres");
      } else {
        sink.add(password);
      }
    }
  );
}