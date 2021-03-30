class User {
  String name;
  String email;
  String phoneNumber;

  User(this.name, this.email, {this.phoneNumber});

  User.fromJson(Map<String, String> parsedJson) {
    this.name = parsedJson["name"];
    this.email = parsedJson["email"];
    this.phoneNumber = parsedJson["phoneNumber"];
  }

  toMap() {
    return <String, String> {
      "name": this.name,
      "email": this.email,
    };
  }
}