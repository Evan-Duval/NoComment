import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 32, 42, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            // Ajout pour permettre le défilement
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: StrokeText(
                    text: 'NoComment',
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.nanumBrushScript(
                      fontSize: 56,
                      color: const Color.fromRGBO(246, 112, 63, 1),
                      fontWeight: FontWeight.bold,
                    ),
                    strokeWidth: 3,
                    strokeColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Créer un compte',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _buildTextField('Nom d\'utilisateur'),
                _buildTextField('Adresse mail'),
                _buildTextField('Mot de passe'),
                _buildTextField('Confirmer mot de passe'),
                _buildTextField('Prénom'),
                _buildTextField('Nom'),
                _buildTextField('Date de naissance'),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: Text('Soumettre',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Déjà un compte ?",
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        cursorColor: Colors.white,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: const Color.fromRGBO(255, 255, 255, 0.8),
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 246, 112, 63)),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 246, 112, 63)),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: RegisterPage()));
}
