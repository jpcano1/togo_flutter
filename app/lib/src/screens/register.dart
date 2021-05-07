import 'package:app/src/bloc/blocs/user/store_vet_creation_bloc.dart';
import 'package:app/src/screens/services/store_vet/store_vet_creation.dart';
import 'package:app/src/widgets/toast_alert.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../widgets/spinner.dart';
import '../widgets/button.dart';
import '../models/user.dart' as UserModel;
import '../utils/notification_dialog.dart';
import '../utils/night_mode.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/blocs/register_bloc.dart';
import './user/profile_picture_upload.dart';

import '../bloc/blocs/update_profile_picture_bloc.dart';

class RegisterScreen extends StatefulWidget {

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  RegisterScreen({this.analytics, this.observer});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String zone;
  bool nightMode = isNightMode();
  bool serviceProvider = false;


  Future <void> _setCurrentScreen() async{
    await widget.analytics.setCurrentScreen(screenName: "Register");
  }
  
  Future<void> _logRegister() async{
    await widget.analytics.logEvent(name: "Register");
  }

  @override
  void initState() {
    zone = "+57";
    super.initState();
    _setCurrentScreen();
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
        iconTheme: IconThemeData(
          color: nightMode? Colors.white: Colors.black
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Text(
              "Register",
              style: Theme.of(context).textTheme.headline4.copyWith(
                color: nightMode? Colors.white: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: StreamBuilder(
                stream: bloc.registerName,
                builder: (streamContext, snapshot) {
                  return TextField(
                    textCapitalization: TextCapitalization.words,
                    onChanged: bloc.changeRegisterName,
                    cursorColor: nightMode? Colors.white: Colors.black,
                    style: TextStyle(
                      color: nightMode? Colors.white: Colors.black
                    ),
                    decoration: InputDecoration(
                      hintText: "John Doe",
                      errorText: snapshot.error
                    ),
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
                  return TextField(
                    onChanged: bloc.changeRegisterEmail,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: nightMode? Colors.white: Colors.black,
                    style: TextStyle(
                      color: nightMode? Colors.white: Colors.black
                    ),
                    decoration: InputDecoration(
                      hintText: "example@mail.com",
                      errorText: snapshot.error
                    ),
                  );
                },
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CountryCodePicker(
                    initialSelection: "CO",
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    textStyle: TextStyle(
                      color: nightMode? Colors.white: Colors.black,
                    ),
                    dialogTextStyle: TextStyle(
                      color: nightMode? Colors.white: Colors.black,
                    ),
                    searchStyle: TextStyle(
                      color: nightMode? Colors.white: Colors.black,
                    ),
                    dialogBackgroundColor: Theme.of(context).backgroundColor,
                    dialogSize: Size(size.width * 0.8, size.height * 0.7),
                    onChanged: (CountryCode value) => setState(() => zone = value.dialCode),
                  ),
                  Flexible(
                    child: StreamBuilder(
                      stream: bloc.registerPhone,
                      builder: (streamContext, snapshot) {
                        return TextField(
                          onChanged: bloc.changeRegisterPhone,
                          keyboardType: TextInputType.phone,
                          cursorColor: nightMode? Colors.white: Colors.black,
                          style: TextStyle(
                            color: nightMode? Colors.white: Colors.black
                          ),
                          decoration: InputDecoration(
                            hintText: "+57 (123) 123 1234",
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
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: StreamBuilder(
                stream: bloc.registerPassword,
                builder: (streamContext, snapshot) {
                  return TextField(
                    onChanged: bloc.changeRegisterPassword,
                    cursorColor: nightMode? Colors.white: Colors.black,
                    style: TextStyle(
                      color: nightMode? Colors.white: Colors.black
                    ),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "password",
                      errorText: snapshot.error
                    ),
                  );
                },
              )
            ),
            Container(
              padding: EdgeInsets.only(right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Are you a service provider?",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                  Checkbox(
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (bool value) {
                      setState(() {
                        this.serviceProvider = value;  
                      });
                    },
                    value: this.serviceProvider,
                  ),
                ],
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: StreamBuilder(
                stream: bloc.registerSubmit,
                builder: (streamContext, snapshot) {
                  return AppButton(
                    color: Theme.of(streamContext).colorScheme.primary,
                    text: "Next",
                    onPressed: snapshot.hasData? register(streamContext, bloc, this.zone): null,
                    minWidth: size.width,
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }

  register(BuildContext context, RegisterBloc bloc, String zone) {
    _register() async {
      dialog(context, content: LoadingSpinner());
      String blocData;
      try {
        blocData = await bloc.register(zone);
      } catch(e) {
        Navigator.pop(context);
        showToast(e, context);
        return;
      }

      Navigator.pop(context);
      showToast("Verify your email inbox", context);

      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (_) => this.serviceProvider? Provider(
            bloc: StoreVetCreationBloc(), 
            child: StoreVetCreationScreen(vetId: blocData)
          ): Provider(
            bloc: UpdateProfilePictureBloc(), 
            child: ProfilePictureUploadScreen(blocData)
          )
        )
      );
    }
    return _register;
  }
}