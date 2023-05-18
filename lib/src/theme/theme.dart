import 'package:flutter/material.dart';

const primaryColor = Color(0xff263B7F);
// #263B7F
var secondaryColor = const Color(0xff3A60AC);

var appTheme = ThemeData(
    textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1, bodyColor: Colors.black, displayColor: Colors.black),
    fontFamily: 'Poppins',
    // useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          primaryColor,
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(140.0, 60.0),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 1.25,
              color: Colors.white),
        ),
      ),
    ),
    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      floatingLabelStyle: TextStyle(color: secondaryColor),
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
        iconTheme: IconThemeData(color: Colors.white)),
    drawerTheme: const DrawerThemeData(backgroundColor: Colors.white));
