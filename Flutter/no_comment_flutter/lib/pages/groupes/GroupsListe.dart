import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:no_comment_flutter/config/config.dart';
import 'package:no_comment_flutter/pages/groupes/GroupContent.dart';
import 'dart:convert';
import 'package:no_comment_flutter/pages/groupes/CreateGroup.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({super.key});

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  List<dynamic> groups = [];
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    final apiUrl = '${dotenv.env['URL']}api/groups/get-all';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        groups = json.decode(response.body);
      });
    } else {
      print('Erreur lors de la récupération des groupes');
    }
  }

  void _toggleForm() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.colors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('GROUPES'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Config.colors.second_backgroundColor,
        actions: [
          IconButton(
            icon: Icon(_showForm ? Icons.close : Icons.add),
            onPressed: _toggleForm,
            color: Config.colors.primaryColor,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            color: Colors.white,
            width: double.infinity,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _showForm
                  ? CreateGroupForm(
                      onGroupCreated: () {
                        fetchGroups();
                        setState(() => _showForm = false);
                      },
                    )
                  : ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        return _buildStyledContainer(
                          group['name'] ?? 'Nom inconnu',
                          group['description'] ?? 'Pas de description',
                          group,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledContainer(
      String title, String subtitle, Map<String, dynamic> group) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Config.colors.second_backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Config.colors.primaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupContent(group: group),
                    ),
                  );
                },
                child: const Text('Accéder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
