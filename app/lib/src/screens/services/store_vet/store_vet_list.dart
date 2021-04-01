import 'store_vet_detail.dart';
import 'package:flutter/material.dart';
import '../../../models/store_vet.dart' as VetModel;
import '../../../widgets/app_bar.dart';

class StoreVetListScreen extends StatefulWidget {
  final bool stores;
  
  StoreVetListScreen({this.stores=false});

  @override
  _StoreVetListScreenState createState() => _StoreVetListScreenState(this.stores);
}

class _StoreVetListScreenState extends State<StoreVetListScreen> {
  List<VetModel.StoreVet> vetList;
  final bool stores;

  _StoreVetListScreenState(this.stores);

  @override
  void initState() {
    vetList = [
      VetModel.StoreVet(
        "Exotic Pet",
        "Email@vet.com",
        {
          "Monday": ["1:00", "2:00"],
          "Tuesday": ["1:00", "2:00"],
          "Wednesday": ["1:00", "2:00"],
          "Thursday": ["1:00", "2:00"],
          "Friday": ["1:00", "2:00"],
          "Weekend": ["1:00", "2:00"],
        },
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
        {
          "Lunes": ["1:00", "2:00"],
          "Martes": ["1:00", "2:00"],
        },
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
        {
          "Lunes": ["1:00", "2:00"],
          "Martes": ["1:00", "2:00"],
        },
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
        {
          "Lunes": ["1:00", "2:00"],
          "Martes": ["1:00", "2:00"],
        },
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
    final size = MediaQuery.of(context).size;
    final defaultVetImagePath = "assets/icons/snakes.png";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.background, 
        iconColor: Colors.black
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: size.width,
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                this.stores? "Stores": "Vets",
                style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: this.vetList.length,
                itemBuilder: (BuildContext listContext, int index) {
                  VetModel.StoreVet storeVet = vetList[index];
                  AssetImage image;

                  if (storeVet.imagePath.isNotEmpty) {
                    image = AssetImage(storeVet.imagePath);
                  } else {
                    image = AssetImage(defaultVetImagePath);
                  }
                  return Card(
                    color: Colors.white70,
                    borderOnForeground: false,
                    elevation: 2.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: image,
                        backgroundColor: Colors.white,
                        maxRadius: size.height * 0.03,
                      ),
                      onTap: () => Navigator.push(
                        listContext, 
                        MaterialPageRoute(
                          builder: (materialPageRouteContext) => StoreVetDetail(storeVet)
                        )
                      ),
                      title: Text(
                        storeVet.name,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.black
                        ),
                      )
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}