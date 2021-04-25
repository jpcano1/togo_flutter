import 'user.dart' as UserModel;

class StoreVet extends UserModel.User {

  Map<String, List<String>> officeHours;
  String catalog;
  List<Map<String, double>> locations;

  StoreVet(String id, String name, 
           String email, this.officeHours, 
           this.catalog,this.locations,
           {String phoneNumber}): 
    super(id, name, email, phoneNumber: phoneNumber);
  
  @override
  StoreVet.fromMap(Map<String, dynamic> map): 
    super.fromMap(map) {
    // Vet Attributes
    this. officeHours = map["officeHours"];
    this.catalog = map["catalog"];
    this.locations = map["locations"];
  }
  
  @override
  toMap() {
    return {
      ...super.toMap(),
      "officeHours": this.officeHours,
      "catalog": this.catalog,
      "locations": this.locations,
    };
  }

  double get averageRating {
    return 0;
  }
}