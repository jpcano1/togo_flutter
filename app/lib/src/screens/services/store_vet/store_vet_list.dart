import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/user/store_vet_list_bloc.dart';
import 'package:app/src/widgets/spinner.dart';
import 'package:flutter/rendering.dart';

import 'store_vet_detail.dart';
import 'package:flutter/material.dart';
import '../../../models/store_vet.dart' as StoreVetModel;
import '../../../widgets/app_bar.dart';
import '../../../utils/night_mode.dart';

class StoreVetListScreen extends StatelessWidget {
  final stores;

  StoreVetListScreen({this.stores=false});

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
              margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
              padding: EdgeInsets.only(left: size.width * 0.05),
              child: Text(
                this.stores? "Stores": "Vets",
                style: Theme.of(context).textTheme.headline4.copyWith(
                  color: nightMode? Colors.white: Colors.black
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: FutureBuilder(
                  future: bloc.getList(this.stores),
                  builder: (_, futureSnapshot) {
                    if (futureSnapshot.connectionState == ConnectionState.done) {
                      return StreamBuilder(
                        stream: bloc.storeVetListStream,
                        builder: (_, streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return buildStoreVetList(
                              context,
                              size, nightMode, 
                              streamSnapshot.data
                            );
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
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  buildStoreVetList(BuildContext context, Size size, bool nightMode, List vetList) {
    final defaultVetImagePath = "assets/icons/snakes.png";
    return ListView.builder(
      itemCount: vetList.length,
      itemBuilder: (BuildContext listContext, int index) {
        StoreVetModel.StoreVet storeVet = vetList[index];
        var image;

        if (storeVet.imagePath.isNotEmpty) {
          image = NetworkImage(storeVet.imagePath);
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
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                ),
                Text(
                  storeVet.averageRating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: nightMode? Colors.white: Colors.black
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}