

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme = ThemeData(
  // useMaterial3: true,
  fontFamily: 'Varela',
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: HexColor('0571d5'),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      fontSize: 19.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'VarelaRound',
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: HexColor('0571d5'),
  ),
);

ThemeData darkTheme = ThemeData(
  // useMaterial3: true,
  fontFamily: 'Varela',
  scaffoldBackgroundColor: HexColor('121212'),
  colorScheme: ColorScheme.dark(
    primary: HexColor('2eb7c9'),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: HexColor('121212'),
    elevation: 0,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: const TextStyle(
      fontSize: 19.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'VarelaRound',
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('121212'),
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: HexColor('2ab9ca'),
  ),
);