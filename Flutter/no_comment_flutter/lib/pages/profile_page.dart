import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _username;
  String? _email;
  String? _bio;
  String? _firstName;
  String? _lastName;
  String? _birthday;
  String? _logo;
  bool? _certified;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _username = prefs.getString('username');
      _email = prefs.getString('email');
      _bio = prefs.getString('bio');
      _firstName = prefs.getString('first_name');
      _lastName = prefs.getString('last_name');
      _birthday = prefs.getString('birthday');
      _logo = prefs.getString('logo');
      _certified = prefs.getBool('certified');
    });

    print("Données chargées :");
    print("Username : $_username");
    print("Email : $_email");
    print("Bio : $_bio");
    print("Prénom : $_firstName");
    print("Nom : $_lastName");
    print("Date de naissance : $_birthday");
    print("Logo : $_logo");
    print("Certifié : $_certified");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17202A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: ListView(
          children: [
            _buildStyledContainer('Nom d\'utilisateur', _username),
            _buildStyledContainer('Email', _email),
            _buildStyledContainer('Bio', _bio),
            _buildStyledContainer('Prénom', _firstName),
            _buildStyledContainer('Nom', _lastName),
            _buildStyledContainer('Date de naissance', _birthday),
            _buildStyledContainer('Logo', _logo),
            _buildStyledContainer(
                'Certifié', _certified != null && _certified! ? 'Oui' : 'Non'),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledContainer(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2C3E50),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              '$label : ',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Text(
                value ?? 'Non disponible',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
