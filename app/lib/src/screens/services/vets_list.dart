import 'package:flutter/material.dart';
import '../../models/vet.dart' as VetModel;

class VetListScreen extends StatefulWidget {
  @override
  _VetListScreenState createState() => _VetListScreenState();
}

class _VetListScreenState extends State<VetListScreen> {
  List<VetModel.StoreVet> vetList;

  _VetListScreenState();

  @override
  void initState() {
    vetList = [
      VetModel.StoreVet(
        "Veterinaria 1",
        "Email@vet.com",
        ["1:00", "2:00"],
        "123123123",
        [
          {"lat": 4.6365921453154995, "lng": -74.09680067805952},
          {"lat": 4.634153971749186, "lng": -74.09474074161847},
          {"lat": 4.65310306395165, "lng": -74.11152064054464}
        ]
      ),
      VetModel.StoreVet(
        "Veterinaria 2",
        "Email@vet.com",
        ["1:00", "2:00"],
        "123123123",
        [
          {"lat": 4.6365921453154995, "lng": -74.09680067805952},
          {"lat": 4.634153971749186, "lng": -74.09474074161847},
          {"lat": 4.65310306395165, "lng": -74.11152064054464}
        ]
      ),
      VetModel.StoreVet(
        "Veterinaria 3",
        "Email@vet.com",
        ["1:00", "2:00"],
        "123123123",
        [
          {"lat": 4.6365921453154995, "lng": -74.09680067805952},
          {"lat": 4.634153971749186, "lng": -74.09474074161847},
          {"lat": 4.65310306395165, "lng": -74.11152064054464}
        ]
      ),
      VetModel.StoreVet(
        "Veterinaria 4",
        "Email@vet.com",
        ["1:00", "2:00"],
        "123123123",
        [
          {"lat": 4.6365921453154995, "lng": -74.09680067805952},
          {"lat": 4.634153971749186, "lng": -74.09474074161847},
          {"lat": 4.65310306395165, "lng": -74.11152064054464}
        ]
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}