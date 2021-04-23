import 'user.dart' as UserModel;

class StoreVet extends UserModel.User {

  Map<String, List<String>> officeHours;
  String contactPhone;
  List<Map<String, double>> locations;

  StoreVet(String id, String name, 
           String email, this.officeHours, 
           this.contactPhone,this.locations,
           {String phoneNumber}): 
    super(id, name, email, phoneNumber: phoneNumber) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.phoneNumber = phoneNumber;
  }
  
  @override
  StoreVet.fromMap(Map<String, dynamic> map): 
    super.fromMap(map) {
    // Vet Attributes
    this. officeHours = map["officeHours"];
    this.contactPhone = map["contactPhone"];
    this.locations = map["locations"];
  }
  
  @override
  toMap() {
    return {
      ...super.toMap(),
      "officeHours": this.officeHours,
      "contactPhone": this.contactPhone,
      "locations": this.locations,
    };
  }

  double get averageRating {
    return 0;
  }
}