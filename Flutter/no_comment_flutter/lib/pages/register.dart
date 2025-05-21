import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_comment_flutter/pages/login.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  void redirectPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final apiUrl = '${dotenv.env['URL']}api/auth/register';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "username": _usernameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "c_password": _confirmPasswordController.text,
          "first_name": _firstNameController.text,
          "last_name": _lastNameController.text,
          "birthday": _birthdayController.text,
          "bio": _bioController.text,
          "logo": "image.png",
          "rank": "user"
        }),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          barrierDismissible: false, // L'utilisateur doit appuyer sur le bouton
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Inscription réussie'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Votre compte a été créé avec succès.'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme le dialogue
                    Navigator.pushNamed(
                        context, '/login'); // Redirige vers la page de login
                  },
                ),
              ],
            );
          },
        );
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String errorMessage =
            responseData['message'] ?? 'Erreur inconnue';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de connexion')),
      );
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StrokeText(
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
                  const SizedBox(height: 20),
                  Text(
                    'Créer un compte',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField('Nom d\'utilisateur', _usernameController,
                      validator: (val) =>
                          val!.isEmpty ? "Nom d'utilisateur requis" : null),
                  _buildTextField('Adresse mail', _emailController,
                      validator: (val) => !EmailValidator.validate(val!)
                          ? "Email invalide"
                          : null),
                  _buildTextField('Mot de passe', _passwordController,
                      obscureText: true,
                      validator: (val) =>
                          val!.length < 12 ? "12 caractères min." : null),
                  _buildTextField(
                    'Confirmer mot de passe',
                    _confirmPasswordController,
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Ce champ est requis';
                      }
                      if (val != _passwordController.text) {
                        return 'Les mots de passe ne correspondent pas';
                      }
                      return null;
                    },
                  ),
                  _buildTextField('Prénom', _firstNameController,
                      validator: (val) =>
                          val!.isEmpty ? "Prénom requis" : null),
                  _buildTextField('Nom', _lastNameController,
                      validator: (val) => val!.isEmpty ? "Nom requis" : null),
                  const SizedBox(height: 10),
                  _buildTexteLargeField(
                    'Bio',
                    _bioController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Ce champ est requis';
                      }
                      if (val.length > 255) {
                        return 'Nombre de caractères maximum : 255';
                      }
                      return null;
                    },
                  ),
                  _buildBirthdayField(context, _birthdayController),
                  const SizedBox(height: 40),
                  ElevatedButton(
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
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => redirectPage(context),
                    child: Text(
                      "Déjà un compte ?",
                      style: GoogleFonts.poppins(
                        color: const Color.fromRGBO(255, 255, 255, 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
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
      ),
    );
  }

  Widget _buildTexteLargeField(String label, TextEditingController controller,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        cursorColor: Colors.white,
        maxLines: 5,
        minLines: 3,
        maxLength: 255,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: GoogleFonts.poppins(
            color: const Color.fromRGBO(255, 255, 255, 0.8),
            fontWeight: FontWeight.bold,
          ),
          contentPadding:
              const EdgeInsets.all(12), // 👈 Espace intérieur du champ
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 246, 112, 63)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 246, 112, 63)),
          ),
        ),
      ),
    );
  }

  Widget _buildBirthdayField(
      BuildContext context, TextEditingController _birthdayController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: const Color.fromRGBO(246, 112, 63, 1),
                    onPrimary: Colors.white,
                    surface: const Color.fromRGBO(23, 32, 42, 1),
                    onSurface: Colors.white,
                  ),
                  dialogBackgroundColor: Color.fromARGB(255, 230, 231, 233),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            setState(() {
              _birthdayController.text =
                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            });
          }
        },
        child: AbsorbPointer(
          child: TextField(
            controller: _birthdayController,
            decoration: InputDecoration(
              labelText: 'Date de naissance',
              labelStyle: GoogleFonts.poppins(
                color: const Color.fromRGBO(255, 255, 255, 0.8),
                fontWeight: FontWeight.bold,
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 246, 112, 63)),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 246, 112, 63)),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
