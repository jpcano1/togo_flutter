import 'package:app/src/utils/checkConnection.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './user/profile_picture_upload.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/blocs/register_bloc.dart';
import '../bloc/blocs/update_profile_picture_bloc.dart';
import '../models/user.dart' as UserModel;
import '../utils/night_mode.dart';
import '../utils/notification_dialog.dart';
import '../widgets/button.dart';
import '../widgets/spinner.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String zone;
  bool nightMode = isNightMode();

  @override
  void initState() {
    zone = "+57";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<RegisterBloc>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        iconTheme:
            IconThemeData(color: nightMode ? Colors.white : Colors.black),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Text(
              "Register",
              style: Theme.of(context).textTheme.headline4.copyWith(
                    color: nightMode ? Colors.white : Colors.black,
                  ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: StreamBuilder(
                stream: bloc.registerName,
                builder: (streamContext, snapshot) {
                  //TODO eliminate commented code
                  // return nameField(bloc, snapshot);
                  return TextFormField(
                    // initialValue: bloc.getName(),
                    controller: bloc.textNameController,
                    onChanged: bloc.changeRegisterName,
                    cursorColor: nightMode ? Colors.white : Colors.black,
                    style: TextStyle(
                        color: nightMode ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                        hintText: "John Doe", errorText: snapshot.error),
                  );
                },
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: StreamBuilder(
                  stream: bloc.registerEmail,
                  builder: (streamContext, snapshot) {
                    return TextFormField(
                      // initialValue: bloc.getEmail(),
                      //TODO eliminate commented code
                      //TODO put texteditingcontroller for email
                      onChanged: bloc.changeRegisterEmail,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: nightMode ? Colors.white : Colors.black,
                      style: TextStyle(
                          color: nightMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                          hintText: "example@mail.com",
                          errorText: snapshot.error),
                    );
                  },
                )),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Row(
                children: [
                  CountryCodePicker(
                    initialSelection: "CO",
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    textStyle: TextStyle(
                      color: nightMode ? Colors.white : Colors.black,
                    ),
                    dialogTextStyle: TextStyle(
                      color: nightMode ? Colors.white : Colors.black,
                    ),
                    searchStyle: TextStyle(
                      color: nightMode ? Colors.white : Colors.black,
                    ),
                    dialogBackgroundColor: Theme.of(context).backgroundColor,
                    dialogSize: Size(size.width * 0.8, size.height * 0.7),
                    onChanged: (CountryCode value) =>
                        setState(() => zone = value.dialCode),
                  ),
                  Expanded(
                      child: StreamBuilder(
                    stream: bloc.registerPhone,
                    builder: (streamContext, snapshot) {
                      return TextFormField(
                        // initialValue: bloc.getPhone(),
                        //TODO eliminate commented code
                        //TODO put texteditingcontroller for phone
                        onChanged: bloc.changeRegisterPhone,
                        keyboardType: TextInputType.phone,
                        cursorColor: nightMode ? Colors.white : Colors.black,
                        style: TextStyle(
                            color: nightMode ? Colors.white : Colors.black),
                        decoration: InputDecoration(
                            hintText: "+57 (123) 123 1234",
                            errorText: snapshot.error),
                      );
                    },
                  ))
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: StreamBuilder(
                  stream: bloc.registerPassword,
                  builder: (streamContext, snapshot) {
                    return TextField(
                      onChanged: bloc.changeRegisterPassword,
                      cursorColor: nightMode ? Colors.white : Colors.black,
                      style: TextStyle(
                          color: nightMode ? Colors.white : Colors.black),
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "password", errorText: snapshot.error),
                    );
                  },
                )),
            Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: StreamBuilder(
                  stream: bloc.registerSubmit,
                  builder: (streamContext, snapshot) {
                    return AppButton(
                      color: Theme.of(streamContext).colorScheme.primary,
                      text: "Next",
                      //TODO: En caso de no tener conexión guardar información
                      onPressed: () {
                        checkConnectivity().then((connected) {
                          print("Está conectado? " + connected.toString());
                          if (connected) {
                            if (snapshot.hasData) {
                              print("Entró a next");
                              register(streamContext, bloc, this.zone);
                            }
                          } else {
                            noConnectionSave(streamContext, bloc);
                          }
                        });
                      },
                      minWidth: size.width,
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }

  //TODO Eliminate unused method
  nameField<Widget>(RegisterBloc bloc, AsyncSnapshot snapshot) {
    _nameField() async {
      await checkConnectivity().then((connected) {
        //   if (connected) {
        return TextField(
          onChanged: bloc.changeRegisterName,
          cursorColor: nightMode ? Colors.white : Colors.black,
          style: TextStyle(color: nightMode ? Colors.white : Colors.black),
          decoration:
              InputDecoration(hintText: "John Doe", errorText: snapshot.error),
        );
        // }
      });
    }
  }

  //TODO Comment method, delete commented code
  noConnectionSave(BuildContext context, RegisterBloc bloc) {
    _noConnectionSave() async {
      // dialog(context, content: LoadingSpinner());
      {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "No internet connection",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Keep in mind you don\'t have an internet connection at the moment, do you want to save your credentials to retry later? (your password won\'t be saved) ',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black,
                  ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  //Possible oportunity to show result after saving
                  bloc.noConnectionSaveCredentials();
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        );
      }
    }

    return _noConnectionSave();
  }

  register(BuildContext context, RegisterBloc bloc, String zone) {
    print("Entro a register de view");
    _register() async {
      print("Entró a _register async");
      dialog(context, content: LoadingSpinner());
      UserModel.User blocData;
      try {
        blocData = await bloc.register(zone);
      } catch (e) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: e,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.primary,
        );
        return;
      }

      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Verify your email inbox",
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      );

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => Provider(
                  bloc: UpdateProfilePictureBloc(),
                  child: ProfilePictureUploadScreen(blocData))));
    }

    return _register;
  }
}
