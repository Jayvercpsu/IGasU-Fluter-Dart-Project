import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const IGasUApp());
}

class IGasUApp extends StatelessWidget {
  const IGasUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iGasU',
      debugShowCheckedModeBanner: false, // Removes debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
