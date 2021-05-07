import 'package:app/src/bloc/blocs/preference_bloc.dart';
import 'package:flutter/material.dart';

class PreferenceProvider with ChangeNotifier {
  PreferenceBloc _bloc;

  PreferenceProvider() {
    _bloc = PreferenceBloc();
  }
}
