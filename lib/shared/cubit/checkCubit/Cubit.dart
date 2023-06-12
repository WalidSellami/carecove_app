
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';

class CheckCubit extends Cubit<CheckStates> {

  CheckCubit() : super(InitialCheckState());

  static CheckCubit get(context) => BlocProvider.of(context);


  // Check Connection

  bool hasInternet = false;

  bool isSplashScreen = true;

  void checkConnection() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      this.hasInternet = hasInternet;
      (isSplashScreen == false) ? showSimpleNotification(
        (hasInternet) ? const Text(
          'You are connected with internet',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ) : const Text(
          'You are not connected with internet',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: (hasInternet) ? HexColor('158b96') : Colors.red,
      ) : null;
      emit(CheckConnectionState());
    });
    // emit(CheckConnectionState());
  }

  void changeStatusScreen() {
    isSplashScreen = false;
    emit(ChangeStatusScreenState());
  }


}