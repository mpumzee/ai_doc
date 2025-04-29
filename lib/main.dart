import 'package:flutter/material.dart';
import 'registration_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const RegistrationPage(), // Set RegistrationPage as the initial page
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.purple[100],
    ),
  );
  static final ThemeData darkTheme = ThemeData.dark();
}
