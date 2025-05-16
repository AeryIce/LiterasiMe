import 'package:flutter/material.dart';
import 'colors.dart'; // import warna-warna tadi

final ThemeData literasiMeTheme = ThemeData(
  scaffoldBackgroundColor: kBackgroundColor,
  appBarTheme: AppBarTheme(
    backgroundColor: kSecondaryColor,
    titleTextStyle: TextStyle(
      color: kTextColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: kPrimaryColor),
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: kTextColor, fontFamily: 'Poppins'),
    titleLarge: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: kPrimaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: kPrimaryColor, width: 2),
    ),
  ),
);
