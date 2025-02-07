import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:no_comment_flutter/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _username;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _birthday;
  String? _logo;
  String? _bio;
  String? _token;
  String? _errorMessage;

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    if (_username != null) prefs.setString('username', _username!);
    if (_firstName != null) prefs.setString('firstName', _firstName!);
    if (_lastName != null) prefs.setString('lastName', _lastName!);
    if (_email != null) prefs.setString('email', _email!);
    if (_birthday != null) prefs.setString('birthday', _birthday!);
    if (_logo != null) prefs.setString('logo', _logo!);
    if (_bio != null) prefs.setString('bio', _bio!);

    print("Token sauvegardé : $token");
  }

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final apiUrl =
        '${dotenv.env['URL']}api/auth/login'; // Utilisation de dotenv

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Récupération des informations utilisateur
        final userInfo = data['user_info'];
        if (userInfo != null) {
          _username = userInfo['username'];
          _email = userInfo['email'];
          _bio = userInfo['bio'];
          _firstName = userInfo['first_name'];
          _lastName = userInfo['last_name'];
          _birthday = userInfo['birthday'];
          _logo = userInfo['logo'];

          print("Données utilisateur obtenues depuis l'API :");
          print(
              "Username : $_username, Email : $_email, Bio : $_bio, Prénom : $_firstName, Nom : $_lastName, Date de naissance : $_birthday, Logo : $_logo");


          // Sauvegarde uniquement si les valeurs ne sont pas null
          if (_username != null &&
              _email != null &&
              _bio != null &&
              _firstName != null &&
              _lastName != null &&
              _birthday != null &&
              _logo != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('username', _username!);
            await prefs.setString('email', _email!);
            await prefs.setString('bio', _bio!);
            await prefs.setString('first_name', _firstName!);
            await prefs.setString('last_name', _lastName!);
            await prefs.setString('birthday', _birthday!);
            await prefs.setString('logo', _logo!);
            print("Données sauvegardées dans SharedPreferences");
          } else {
            print("Certaines données utilisateur sont null");
          }
        }

        _token = data['accessToken'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);

        setState(() {
          _errorMessage = null;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          _errorMessage = errorData['message'] ?? 'Erreur de connexion.';
        });
      }
    } catch (e) {
      
      setState(() {
        _errorMessage = 'Une erreur s\'est produite : $e';
      });
    }
  }

  void redirectPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              'Connexion',
              style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: TextField(
              cursorColor: Color.fromRGBO(255, 255, 255, 0.8),
              controller: _emailController,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                labelText: 'Adresse mail',
                labelStyle: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: TextFormField(
              cursorColor: Color.fromRGBO(255, 255, 255, 0.8),
              controller: _passwordController,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              obscureText: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                labelText: 'Mot de passe',
                labelStyle: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 54),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
              ),
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Soumettre',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: GestureDetector(
                onTap: () => redirectPage(context),
                child: Text(
                  'S\'inscrire ici',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: MyCustomForm()));
}
