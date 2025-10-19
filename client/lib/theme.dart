import 'package:flutter/material.dart';

final theme = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 1, // 그림자 정도
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
    actionsIconTheme: IconThemeData(color: Colors.white),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0D2138),
    selectedItemColor: Color(0xFF34639B),
    unselectedItemColor: Colors.white,    
    selectedIconTheme: IconThemeData(color: Color(0xFF34639B)),
    unselectedIconTheme: IconThemeData(color: Colors.white),

  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF34639B),
    surface: Color(0xFF0D2138),
    onSurface: Colors.white,

  ),
  
);