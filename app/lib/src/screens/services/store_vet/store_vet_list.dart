import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/user/store_vet_list_bloc.dart';
import 'package:app/src/widgets/spinner.dart';
import 'package:flutter/rendering.dart';

import 'store_vet_detail.dart';
import 'package:flutter/material.dart';
import '../../../models/store_vet.dart' as StoreVetModel;
import '../../../widgets/app_bar.dart';
import '../../../utils/night_mode.dart';

class StoreVetListScreen extends StatefulWidget {
  final bool stores;
  
  StoreVetListScreen({this.stores=false});

  @override
  _StoreVetListScreenState createState() => _StoreVetListScreenState();
}

class _StoreVetListScreenState extends State<StoreVetListScreen> {
  bool stores;
  String _selected = "name";
  bool _visible = false;
  List<StoreVetModel.StoreVet> vetList;

  List<String> criteria = ["name", "rating"];

  @override
  void initState() {
    super.initState();
    stores = widget.stores;
  }

  @override
  Widget build(BuildContext context) {
    bool nightMode = isNightMode();
    final size = MediaQuery.of(context).size;
    final bloc = Provider.of<StoreVetListBloc>(context);

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
              child: FutureBuilder(
                future: bloc.getList(this.stores),
                builder: (_, futureSnapshot) {
                  if (futureSnapshot.connectionState == ConnectionState.done) {
                    return StreamBuilder(
                      stream: bloc.storeVetListStream,
                      builder: (_, streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          setState(() {
                            vetList = streamSnapshot.data;
                          });
                          return buildStoreVetList(size, nightMode);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: LoadingSpinner(),
                          );
                        }
                        return Center(
                          child: LoadingSpinner(),
                        );
                      }
                    );
                  }
                  if (futureSnapshot.hasError) {
                    return Center(
                      child: Text(futureSnapshot.error)
                    );
                  }
                  return Center(
                    child: LoadingSpinner(),
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }

  buildStoreVetList(Size size, bool nightMode) {
    final defaultVetImagePath = "assets/icons/snakes.png";
    return ListView.builder(
      itemCount: vetList.length,
      itemBuilder: (BuildContext listContext, int index) {
        StoreVetModel.StoreVet storeVet = vetList[index];
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
          ),
        );
      },
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