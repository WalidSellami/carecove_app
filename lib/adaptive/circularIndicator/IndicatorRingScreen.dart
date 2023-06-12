import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class IndicatorRingScreen extends StatelessWidget {

  final String os;
  const IndicatorRingScreen({super.key, required this.os});

  @override
  Widget build(BuildContext context) {

    if(os == 'android'){

      return SpinKitRing(
        color: ThemeCubit.get(context).isDark ? HexColor('15909d') : HexColor('0571d5'),
        size: 30.0,
        lineWidth: 3.0,
      );

    } else {

      return SpinKitFadingCircle(
        color: ThemeCubit.get(context).isDark ? HexColor('15909d') : HexColor('0571d5'),
        size: 30.0,
      );

    }
  }
}
