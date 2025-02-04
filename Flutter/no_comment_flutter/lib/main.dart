import 'package:flutter/material.dart';
import 'package:no_comment_flutter/pages/login.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login', 
      routes: {
        '/login': (context) => const LoginPage(),
      },
    );
  }
}