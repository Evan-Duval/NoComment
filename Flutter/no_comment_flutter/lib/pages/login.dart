import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:no_comment_flutter/config/config.dart';
import 'package:no_comment_flutter/pages/form_login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF17202A),
        title: StrokeText(
          text: 'NoComment',
          textStyle: GoogleFonts.nanumBrushScript(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: Config.colors.primaryColor,
          ),
          strokeColor: Colors.black,
          strokeWidth: 6,
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: const Color(0xFF17202A),
      body: const Center(
        child: MyCustomForm(),
      ),
    );
  }
}
