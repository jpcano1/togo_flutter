import 'package:app/src/models/pet.dart';

class User {
  String name;
  String email;
  String phoneNumber;
  String imagePath;
  List<Pet> pets = <Pet>[];

  User(this.name, this.email, {
    this.phoneNumber, 
    this.pets, 
    this.imagePath=""
  });

  User.fromJson(Map<String, String> parsedJson) {
    this.name = parsedJson["name"];
    this.email = parsedJson["email"];
    this.phoneNumber = parsedJson["phoneNumber"];
  }

  toMap() {
    return <String, String> {
      "name": this.name,
      "email": this.email,
      "phoneNumber": this.phoneNumber
    };
  }
}