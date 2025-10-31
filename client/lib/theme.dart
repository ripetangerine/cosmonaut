import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(

  fontFamily: "DungGeunMo",

  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white), 
    bodyMedium: TextStyle(color: Colors.white), 
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
    labelLarge: TextStyle(color: Colors.white), 
    labelSmall: TextStyle(color: Colors.white),
  ).apply(
    bodyColor: Colors.white, 
    displayColor: Colors.white, 
  ),

  // 앱 전체 기본 색상 체계
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF34639B),
    surface: Color(0xFF0D2138),  // 카드, 바탕면 색상
    onSurface: Colors.white,
  ),

  scaffoldBackgroundColor: const Color(0xFF0D2138),

  // AppBar 스타일
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0D2138), // AppBar 배경색 (color 대신 backgroundColor)
    elevation: 1, // 그림자 깊이
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: IconThemeData(color: Colors.white), // leading icon
    actionsIconTheme: IconThemeData(color: Colors.white),
  ),

  // BottomNavigationBar 스타일
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0D2138),
    selectedItemColor: Color(0xFF34639B),
    unselectedItemColor: Colors.white,
    selectedIconTheme: IconThemeData(color: Color(0xFF34639B)),
    unselectedIconTheme: IconThemeData(color: Colors.white),
  ),
);
