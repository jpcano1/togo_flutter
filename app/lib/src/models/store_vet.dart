import 'user.dart' as UserModel;

class StoreVet extends UserModel.User {

  Map officeHours;
  String catalog;
  List locations;
  double averageRating;

  StoreVet(String id, String name, 
           String email, this.officeHours, 
           this.catalog,this.locations, this.averageRating,
           {String phoneNumber}): 
    super(id, name, email, phoneNumber: phoneNumber);
  
  @override
  StoreVet.fromMap(Map<String, dynamic> map): 
    super.fromMap(map) {
    // Vet Attributes
    this.catalog = map["catalog"];
    this. officeHours = map["officeHours"];
    this.locations = map["locations"];
    this.averageRating = map["averageRating"]?? 0;
  }
  
  @override
  toMap() {
    return {
      ...super.toMap(),
      "officeHours": this.officeHours,
      "catalog": this.catalog,
      "locations": this.locations,
      "averageRating": this.averageRating
    };
  }
}