import 'package:app/src/models/pet.dart';

class User {
  String id;
  String name;
  String email;
  String phoneNumber;
  String imagePath;
  List<Pet> pets;
  bool petOwner = true;
  bool store = false;
  bool vet = false;
  bool walker = false;

  User(this.id, this.name, this.email,
      {this.phoneNumber, this.imagePath = "", List<Pet> pets}) {
    this.pets = pets ?? [];
  }

  User.fromJson(Map<String, dynamic> parsedJson) {
    this.name = parsedJson["name"];
    this.email = parsedJson["email"];
    this.phoneNumber = parsedJson["phoneNumber"];
    this.imagePath = parsedJson["imagePath"];
    this.pets = List.generate(parsedJson["pets"].length,
        (index) => Pet.fromJson(parsedJson["pets"][index]));
  }

  toMap() {
    return <String, dynamic>{
      "name": this.name,
      "email": this.email,
      "phoneNumber": this.phoneNumber,
      "imagePath": this.imagePath,
      "pets": this.pets,
      "petOwner": true,
      "store": false,
      "walker": false,
      "vet": false,
    };
  }
}
