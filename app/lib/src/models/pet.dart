class Pet {
  String name;
  String type;
  String breed;
  String height;
  String weight;
  int age;
  String birthday;
  String imagePath;

  Map<String, double> location;

  Pet(this.name, this.age, {this.imagePath=""});

  Pet.fromJson(Map<String, dynamic> parsedJson) {
    this.name = parsedJson["name"];
    this.age = int.tryParse(parsedJson["age"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "age": this.age
    };
  }
}