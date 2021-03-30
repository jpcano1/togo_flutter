import 'user.dart' as UserModel;

class StoreVet extends UserModel.User {

  List<String> officeHours;
  String contactPhone;
  List<Map<String, double>> locations;

  StoreVet(String name, 
           String email, this.officeHours, 
           this.contactPhone, 
           this.locations, {String phoneNumber}): 
    super(name, email, phoneNumber: phoneNumber);
  
  @override
  StoreVet.fromJson(Map<String, String> parsedJson): 
    super.fromJson(parsedJson);
  
  @override
  toMap() {
    Map<String, dynamic> map = super.toMap();
    map["officeHours"] = this.officeHours;
    map["contactPhone"] = this.contactPhone;
    map["locations"] = this.locations;
    return map;
  }
}