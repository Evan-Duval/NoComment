import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  Future<void> _submitRegistration() async {
    final apiUrl =
        '${dotenv.env['URL']}api/auth/register'; // Utilisation de dotenv

    // Création de la payload pour la requête
    final Map<String, dynamic> userData = {
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "username": _usernameController.text,
      "birthday": _birthdayController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "c_password": _confirmPasswordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Inscription réussie : ${responseData['message']}")));
      } else {
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Erreur : ${errorData['error'] ?? 'Inscription échouée'}")));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Une erreur est survenue. Veuillez réessayer.")));
    }
  }

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
                _buildTextField('Nom d\'utilisateur', _usernameController),
                _buildTextField('Adresse mail', _emailController),
                _buildTextField('Mot de passe', _passwordController,
                    obscureText: true),
                _buildTextField(
                    'Confirmer mot de passe', _confirmPasswordController,
                    obscureText: true),
                _buildTextField('Prénom', _firstNameController),
                _buildTextField('Nom', _lastNameController),
                _buildTextField('Date de naissance', _birthdayController),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Soumettre',
                      style: TextStyle(color: Colors.white),
                    ),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
