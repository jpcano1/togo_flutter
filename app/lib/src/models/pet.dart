class Pet {
  String name;
  String type;
  String breed;
  double height;
  double weight;
  int age;
  String birthday;
  String imagePath;

  Map<String, double> location;

  Pet(
    this.name, this.type, this.breed, 
    this.height, this.weight, this.age, 
    this.birthday, {this.imagePath=""}
  );

  Pet.fromMap(Map<String, dynamic> map) {
    this.name = map["name"];
    this.type = map["type"];
    this.breed = map["breed"];
    this.height = double.tryParse(map["height"]);
    this.weight = double.tryParse(map["weight"]);
    this.age = int.tryParse(map["age"]);
    this.birthday = map["birthday"];
    this.imagePath = map["imagePath"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "type": this.type,
      "breed": this.breed,
      "height": this.height,
      "weight": this.weight,
      "age": this.age,
      "birthday": this.birthday,
      "imagePath": this.imagePath
    };
  }
}