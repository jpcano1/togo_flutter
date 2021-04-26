class User {
  String id;
  String name;
  String email;
  String phoneNumber;
  String imagePath;
  bool petOwner = true;
  bool store = false;
  bool vet = false;
  bool walker = false;

  User(this.id, this.name, this.email,
      {this.phoneNumber, this.imagePath = ""});

  User.fromMap(Map<String, dynamic> map) {
    this.name = map["name"];
    this.email = map["email"];
    this.phoneNumber = map["phoneNumber"];
    this.imagePath = map["imagePath"];
    this.petOwner = map["petOwner"];
    this.vet = map["vet"];
    this.walker = map["walker"];
    this.store = map["store"];
  }

  toMap() {
    return <String, dynamic>{
      "name": this.name,
      "email": this.email,
      "phoneNumber": this.phoneNumber,
      "imagePath": this.imagePath,
      "petOwner": true,
      "store": false,
      "walker": false,
      "vet": false,
    };
  }
}
