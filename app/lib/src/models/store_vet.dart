import 'user.dart' as UserModel;
import 'rating.dart';

class StoreVet extends UserModel.User {

  Map<String, List<String>> officeHours;
  String contactPhone;
  List<Map<String, double>> locations;
  List<Rating> ratings;

  StoreVet(String id, String name, 
           String email, this.officeHours, 
           this.contactPhone,this.locations,
           {String phoneNumber, List<Rating> ratings}): 
    super(id, name, email, phoneNumber: phoneNumber) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.ratings = ratings?? <Rating>[];
  }
  
  @override
  StoreVet.fromMap(Map<String, dynamic> map): 
    super.fromMap(map) {
    // User Attributes
    this.name = map["name"];
    this.email = map["email"];
    this.phoneNumber = map["phoneNumber"];
    // Vet Attributes
    this. officeHours = map["officeHours"];
    this.contactPhone = map["contactPhone"];
    this.locations = map["locations"];
    this.ratings = List.generate(map["ratings"].length, 
        (index) => Rating.fromMap(map["ratings"][index]));
  }
  
  @override
  toMap() {
    return {
      ...super.toMap(),
      "officeHours": this.officeHours,
      "contactPhone": this.contactPhone,
      "locations": this.locations,
      "ratings": this.ratings
    };
  }

  double get averageRating {
    if (this.ratings.isEmpty) {
      return 0;
    }

    double sum = 0;
    for (Rating rating in this.ratings) {
      sum += rating.score;
    }

    return sum / this.ratings.length;
  }
}