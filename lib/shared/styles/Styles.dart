import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
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
      fontSize: 17.5,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Varela',
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  ),
  cardTheme: const CardTheme(
    color: Colors.white,
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Varela',
  scaffoldBackgroundColor: HexColor('141414'),
  colorScheme: ColorScheme.dark(
    primary: HexColor('2eb7c9'),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: HexColor('141414'),
    elevation: 0,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: const TextStyle(
      fontSize: 17.5,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'Varela',
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('141414'),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: HexColor('141414'),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.grey.shade900.withOpacity(.2),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.grey.shade900,
  ),
);