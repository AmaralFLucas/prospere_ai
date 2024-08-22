import 'package:flutter/material.dart';
import 'package:prospere_ai/login.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: false,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Color.fromARGB(255, 30, 163, 132),
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    ),
  ));
}
