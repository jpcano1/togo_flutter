import 'user.dart' as UserModel;

class StoreVet extends UserModel.User {

  Map<String, List<String>> officeHours;
  String contactPhone;
  List<Map<String, double>> locations;

  StoreVet(String name, 
           String email, this.officeHours, 
           this.contactPhone, 
           this.locations, {String phoneNumber}): 
    super(name, email, phoneNumber: phoneNumber) {
      this.name = name;
      this.email = email;
      this.phoneNumber = phoneNumber;
    }
  
  @override
  StoreVet.fromJson(Map<String, String> parsedJson): 
    super.fromJson(parsedJson) {
      // User Attributes
      this.name = parsedJson["name"];
      this.email = parsedJson["email"];
      this.phoneNumber = parsedJson["phoneNumber"];

      // Vet Attributes
    }
  
  @override
  toMap() {
    return {
      ...super.toMap(),
      "officeHoursce": this.officeHours,
      "contactPhone": this.contactPhone,
      "locations": this.locations
    };
  }
}