import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:no_comment_flutter/pages/home.dart';
import 'package:no_comment_flutter/pages/register.dart';
import 'package:no_comment_flutter/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: 'https://cblssbvfgxtadeevsldy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNibHNzYnZmZ3h0YWRlZXZzbGR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NDE3MzMsImV4cCI6MjA2MzMxNzczM30.6vfHowlW_UT2jeO1MdaqlB6lWWd3qloqppOAsUCD3Ts',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
