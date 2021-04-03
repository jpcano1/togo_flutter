import 'user.dart' as UserModel;

class StoreVet extends UserModel.User {

  Map<String, List<String>> officeHours;
  String contactPhone;
  List<Map<String, double>> locations;
  double averageRating;

  StoreVet(String id, String name, 
           String email, this.officeHours, 
           this.contactPhone, this.averageRating,
           this.locations, {String phoneNumber}): 
    super(id, name, email, phoneNumber: phoneNumber) {
      this.id = id;
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
      "officeHours": this.officeHours,
      "contactPhone": this.contactPhone,
      "locations": this.locations
    };
  }
}