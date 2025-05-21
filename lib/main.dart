import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swifty_companion/api/authpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,     
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Swifty Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF7941D),
          primary: const Color(0xFFF7941D),
        ),
        useMaterial3: true,
        fontFamily: 'mytwo',
      ),
      home: const AuthPage(),
    );
  }
}
