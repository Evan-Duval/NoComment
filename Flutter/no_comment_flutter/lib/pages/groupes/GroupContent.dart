import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:no_comment_flutter/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupContent extends StatefulWidget {
  final Map<String, dynamic> group;

  const GroupContent({super.key, required this.group});

  @override
  State<GroupContent> createState() => _GroupContentState();
}

class _GroupContentState extends State<GroupContent> {
  bool isFollowing = false;
  bool isLoading = true;

  final apiUrl = '${dotenv.env['URL']}'; // Change ici avec ton URL

  @override
  void initState() {
    super.initState();
    _checkIfFollowing();
  }

  Future<void> _checkIfFollowing() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(
            '$apiUrl' 'api/groups/${widget.group['id_group']}/follow-status'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          isFollowing = data['is_following'] ?? false;
          isLoading = false;
        });
      } else {
        throw Exception('Erreur API status follow');
      }
    } catch (e) {
      print('Erreur _checkIfFollowing: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _toggleFollow() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(
            '$apiUrl' 'api/groups/${widget.group['id_group']}/toggle-follow'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          isFollowing = data['following'] ?? false;
          isLoading = false;
        });
      } else {
        throw Exception('Erreur API toggle follow');
      }
    } catch (e) {
      print('Erreur _toggleFollow: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17202A),
      appBar: AppBar(
        title: Text(widget.group['name'] ?? 'Groupe'),
        backgroundColor: const Color(0xFF2C3E50),
        actions: [
          IconButton(
            icon: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    isFollowing ? Icons.favorite : Icons.favorite_border,
                    color: isFollowing
                        ? Config.colors.primaryColor
                        : Colors.white70,
                    size: 30,
                  ),
            onPressed: isLoading ? null : _toggleFollow,
            tooltip: isFollowing ? 'Ne plus suivre' : 'Suivre',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group['name'] ?? 'Nom inconnu',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.group['description'] ?? 'Pas de description',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            // Ici tu peux ajouter plus d'infos sur le groupe si besoin
          ],
        ),
      ),
    );
  }
}
