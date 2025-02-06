import 'package:flutter/material.dart';
import 'package:no_comment_flutter/widget/navigation_sidebar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _currentScreen = const Center(
    child: Text(
      "Bienvenue sur la page Profil",
      style: TextStyle(color: Colors.white),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17202A),
      body: Row(
        children: [
          NavigationSidebar(
            onNavigate: (newScreen) {
              setState(() {
                _currentScreen = newScreen;
              });
            },
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _currentScreen,
            ),
          ),
        ],
      ),
    );
  }
}
