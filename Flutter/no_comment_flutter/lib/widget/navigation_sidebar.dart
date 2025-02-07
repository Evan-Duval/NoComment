import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_comment_flutter/config/config.dart';
import 'package:no_comment_flutter/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:no_comment_flutter/pages/profile_page.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:no_comment_flutter/pages/form_login.dart';

class NavigationSidebar extends StatelessWidget {
  final Function(Widget) onNavigate;

  const NavigationSidebar({super.key, required this.onNavigate});



  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); 

    if (token == null) {
      _navigateToLogin(context);
      return;
    }

    final apiUrl = '${dotenv.env['URL']}api/auth/logout';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token'); 
        _navigateToLogin(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Échec de la déconnexion')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: Config.colors.second_backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              onNavigate(const Center(
                child:
                    Text('Page Accueil', style: TextStyle(color: Colors.white)),
              ));
            },
            child: StrokeText(
              text: 'NC',
              textStyle: GoogleFonts.nanumBrushScript(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: Config.colors.primaryColor,
              ),
              strokeColor: Colors.black,
              strokeWidth: 4,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          _buildNavIcon(Icons.search, "Recherche", () {
            onNavigate(const Center(
              child: Text('Recherche', style: TextStyle(color: Colors.white)),
            ));
          }),
          const SizedBox(height: 20),
          _buildNavIcon(Icons.person, "Profil", () {
            onNavigate(ProfilePage());
          }),
          const SizedBox(height: 20),
          _buildNavIcon(Icons.group, "Groupe", () {
            onNavigate(const Center(
              child: Text('Page Groupe', style: TextStyle(color: Colors.white)),
            ));
          }),
          const Spacer(),
          const SizedBox(height: 20),
          _buildNavIcon(Icons.settings, "Paramètres", () {
            onNavigate(const Center(
              child: Text('Page Paramètres',
                  style: TextStyle(color: Colors.white)),
            ));
          }),
          const SizedBox(height: 20),
          _buildNavIcon(Icons.logout, "Déconnexion", () async {
            await _logout(context);
          }),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String tooltip, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Config.colors.primaryColor),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: onTap,
    );
  }
}
