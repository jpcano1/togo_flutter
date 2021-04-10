import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/pet/create_pet_bloc.dart';
import 'package:app/src/widgets/spinner.dart';
import 'package:app/src/widgets/toast_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/pet.dart';
import '../../widgets/app_bar.dart';
import '../../utils/night_mode.dart';
import '../../utils/notification_dialog.dart';

import 'package:flutter/material.dart';

class PetRegisterScreen extends StatefulWidget {
  @override
  _PetRegisterScreenState createState() => _PetRegisterScreenState();
}

class _PetRegisterScreenState extends State<PetRegisterScreen> {
  String date;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CreatePetBloc>(context);
    bool nightMode = isNightMode();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.secondary, 
        iconColor: nightMode? Colors.white: Colors.black
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.secondary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: size.width * 0.05),
                alignment: Alignment.centerLeft,
                child: Text(
                  "New",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Colors.black
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.04),
                alignment: Alignment.center,
                child: IconButton(
                  icon: Image.asset(
                    "assets/icons/image.png",
                  ),
                  onPressed: () => print("Hola"),
                  iconSize: size.width * 0.4,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                  top: size.height * 0.03,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black,
                      width: 1.0
                    )
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: StreamBuilder(
                        stream: bloc.nameOut,
                        builder: (_, snapshot) {
                          return TextField(
                            onChanged: bloc.nameChange,
                            style: TextStyle(
                              color: Colors.black
                            ),
                            textCapitalization: TextCapitalization.words,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: "Name",
                              errorText: snapshot.error
                            ),
                          );
                        },
                      )
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: StreamBuilder(
                        stream: bloc.breedOut,
                        builder: (_, snapshot) {
                          return TextField(
                            onChanged: bloc.breedChange,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              color: Colors.black
                            ),
                            decoration: InputDecoration(
                              hintText: "Breed",
                              errorText: snapshot.error
                            ),
                          );
                        },
                      )
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: StreamBuilder(
                              stream: bloc.heightOut,
                              builder: (_, snapshot) {
                                return TextField(
                                  onChanged: bloc.heightChange,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.black,
                                  style: TextStyle(
                                    color: Colors.black
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Height",
                                    errorText: snapshot.error
                                  ),
                                );
                              },
                            )
                          ),
                          Padding(padding: EdgeInsets.all(5.0)),
                          Flexible(
                            child: StreamBuilder(
                              stream: bloc.weightOut,
                              builder: (_, snapshot) {
                                return TextField(
                                  onChanged: bloc.weightChange,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.black,
                                  style: TextStyle(
                                    color: Colors.black
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Weight",
                                    errorText: snapshot.error
                                  ),
                                );
                              },
                            )
                          ),
                          Padding(padding: EdgeInsets.all(5.0)),
                          Flexible(
                            child: StreamBuilder(
                              stream: bloc.ageOut,
                              builder: (_, snapshot) {
                                return TextField(
                                  onChanged: bloc.ageChange,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.black,
                                  style: TextStyle(
                                    color: Colors.black
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Age",
                                    errorText: snapshot.error
                                  ),
                                );
                              },
                            )
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: OutlinedButton(
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.black,
                            ),
                            Text(
                              "${date?? 'Pick a Birthday!'}",
                              style: TextStyle(
                                color: Colors.black
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showDatePicker(
                            context: context, 
                            initialDate: DateTime.now(), 
                            firstDate: DateTime(1990), 
                            lastDate: DateTime.now()
                          ).then((DateTime date) {
                            if (date != null) {
                                setState(() {
                                this.date = "${date.day}/${date.month}/${date.year}";
                              });
                              bloc.birthdayChange("${date.day}/${date.month}/${date.year}");
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.05),
                width: size.width * 0.23,
                child: TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.save,
                        color: Colors.black,
                      ),
                      Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.black
                        ),
                      )
                    ],
                  ),
                  onPressed: () async {
                    if (this.date == null) {
                      dialog(context, message: "You have to pick a date!");
                      return;
                    } else {
                      try {
                        dialog(context, content: LoadingSpinner());
                        await bloc.createPet();
                        Navigator.pop(context);
                        showToast("Pet created", context);
                        Navigator.pop(context);
                      } catch(e) {
                        print(e);
                        Navigator.pop(context);
                        showToast(e, context);
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}