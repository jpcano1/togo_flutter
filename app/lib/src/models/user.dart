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

  User.fromMap(Map<String, dynamic> map) {
    this.name = map["name"];
    this.email = map["email"];
    this.phoneNumber = map["phoneNumber"];
    this.imagePath = map["imagePath"];
    this.pets = List.generate(map["pets"].length,
        (index) => Pet.fromMap(map["pets"][index]));
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
