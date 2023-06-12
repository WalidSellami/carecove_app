import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class IndicatorScreen extends StatelessWidget {

  final String os;
  const IndicatorScreen({super.key, required this.os});

  @override
  Widget build(BuildContext context) {

      if(os == 'android'){

        return CircularProgressIndicator(color: ThemeCubit.get(context).isDark ? HexColor('15909d') : HexColor('0571d5'),);

      } else {

        return CupertinoActivityIndicator(color: ThemeCubit.get(context).isDark ? HexColor('15909d') : HexColor('0571d5'),);

      }
  }
}
