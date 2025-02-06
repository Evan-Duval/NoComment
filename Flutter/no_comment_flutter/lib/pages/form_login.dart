import 'package:flutter/material.dart';
import 'package:no_comment_flutter/pages/register.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  void redirectPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
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
                onPressed: () {},
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
