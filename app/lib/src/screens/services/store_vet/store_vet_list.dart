import 'package:flutter/rendering.dart';

import 'store_vet_detail.dart';
import 'package:flutter/material.dart';
import '../../../models/store_vet.dart' as VetModel;
import '../../../widgets/app_bar.dart';
import '../../../utils/night_mode.dart';

class StoreVetListScreen extends StatefulWidget {
  final bool stores;
  
  StoreVetListScreen({this.stores=false});

  @override
  _StoreVetListScreenState createState() => _StoreVetListScreenState(this.stores);
}

class _StoreVetListScreenState extends State<StoreVetListScreen> {
  List<VetModel.StoreVet> vetList;
  final bool stores;
  String _selected = "name";
  bool _visible = false;

  List<String> criteria = ["name", "rating"];

  _StoreVetListScreenState(this.stores);

  @override
  void initState() {
    vetList = [
      VetModel.StoreVet(
        "1",
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
        "123123123", 2.1,
        [
          {"lat": 4.6365921453154995, "lng": -74.09680067805952},
          {"lat": 4.634153971749186, "lng": -74.09474074161847},
          {"lat": 4.65310306395165, "lng": -74.11152064054464}
        ]
      ),
      VetModel.StoreVet(
        "2",
        "New Med Vet",
        "Email@vet.com",
        {
          "Lunes": ["1:00", "2:00"],
          "Martes": ["1:00", "2:00"],
        },
        "123123123", 1.2,
        [
          {"lat": 4.6365921453154995, "lng": -74.09680067805952},
          {"lat": 4.634153971749186, "lng": -74.09474074161847},
          {"lat": 4.65310306395165, "lng": -74.11152064054464}
        ]
      ),
      VetModel.StoreVet(
        "3",
        "The Golden Century",
        "Email@vet.com",
        {
          "Lunes": ["1:00", "2:00"],
          "Martes": ["1:00", "2:00"],
        },
        "123123123", 4.6,
        [
          {"lat": 4.6365921453154995, "lng": -74.09680067805952},
          {"lat": 4.634153971749186, "lng": -74.09474074161847},
          {"lat": 4.65310306395165, "lng": -74.11152064054464}
        ]
      ),
      VetModel.StoreVet(
        "4",
        "Country Vet",
        "Email@vet.com",
        {
          "Lunes": ["1:00", "2:00"],
          "Martes": ["1:00", "2:00"],
        },
        "123123123", 3.5,
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
    bool nightMode = isNightMode();
    final size = MediaQuery.of(context).size;
    final defaultVetImagePath = "assets/icons/snakes.png";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.background, 
        iconColor: nightMode? Colors.white: Colors.black
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: size.width,
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.4,
                    child: Text(
                      this.stores? "Stores": "Vets",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                        color: nightMode? Colors.white: Colors.black
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(left: size.width * 0.15),
                    width: size.width * 0.4,
                    child: IconButton(
                      icon: Icon(
                        Icons.sort,
                        color: nightMode? Colors.white: Colors.black,
                      ), 
                      onPressed: () {
                        setState(() {
                          this._visible = !this._visible;
                        });
                      }
                    ),
                  )
                ],
              )
            ),
            Visibility(
              visible: this._visible,
              child: Container(
                height: size.height * 0.15,
                child: ListView(
                  children: List.generate(
                    this.criteria.length, 
                    (index) => ListTile(
                      title: Text(
                        this.criteria[index],
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: nightMode? Colors.white: Colors.black
                        ),
                      ),
                      leading: Radio(
                        activeColor: nightMode? Colors.white: Colors.black,
                        value: this.criteria[index],
                        groupValue: this._selected,
                        onChanged: (String value) {
                          setState(() {
                            this._selected = value;
                          });
                          this.sortStoreVet(value);
                        },
                      ),
                    )
                  ),
                ),
              )
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
                    color: nightMode? Colors.black: Colors.white,
                    shadowColor: nightMode? Colors.white: Colors.black,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: image,
                        backgroundColor: Colors.white,
                        maxRadius: size.height * 0.03,
                      ),
                      onTap: () => Navigator.push(
                        listContext, 
                        MaterialPageRoute(
                          builder: (_) => StoreVetDetail(storeVet)
                        )
                      ),
                      title: Text(
                        storeVet.name,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                          color: nightMode? Colors.white: Colors.black
                        ),
                      ),
                      subtitle: Text(
                        "Rating: ${storeVet.averageRating}",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: nightMode? Colors.white: Colors.black
                        ),
                      ),
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

  void sortStoreVet(String criteria) {
    if (criteria == "name") {
      setState(() {
        this.vetList.sort((a, b) => 
          b.name.toLowerCase().compareTo(a.name.toLowerCase())
        );
      });
    } else {
      setState(() {
        this.vetList.sort((a, b) => 
          b.averageRating.compareTo(a.averageRating)
        );
      });
    }
  }
}