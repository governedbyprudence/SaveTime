 import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS:OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.android:OpenUpwardsPageTransitionsBuilder()
      }
  ),
  primaryColor: const Color(0xff00a896),
  primaryColorDark: const Color(0xff4a4d59),
  scaffoldBackgroundColor: const Color(0xffffffff),
  textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Color(0xff00a896)))
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff322214)))
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xff322214),
  ),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.white,elevation: 0,iconTheme: IconThemeData(color:Color(0xff00a896)),titleTextStyle: TextStyle(color: Color(0xff00a896))),
  primarySwatch: Colors.green,
);

const Color lightPink = Color(0xfffceef9);