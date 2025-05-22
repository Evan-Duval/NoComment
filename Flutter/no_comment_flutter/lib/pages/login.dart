import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:no_comment_flutter/pages/form_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 32, 42, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StrokeText(
                  text: 'NoComment',
                  textAlign: TextAlign.center,
                  textStyle: GoogleFonts.nanumBrushScript(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(246, 112, 63, 1),
                  ),
                  strokeColor: Colors.black,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 20),
                const MyCustomForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
