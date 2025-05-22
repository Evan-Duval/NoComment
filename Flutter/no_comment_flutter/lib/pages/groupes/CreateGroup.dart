import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGroupForm extends StatefulWidget {
  final VoidCallback onGroupCreated;

  const CreateGroupForm({Key? key, required this.onGroupCreated})
      : super(key: key);

  @override
  _CreateGroupFormState createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int? _userId;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('id');
    });
  }

  Future<void> _createGroup() async {
    if (_userId == null) {
      print("Erreur : utilisateur non connecté");
      return;
    }

    setState(() {
      _loading = true;
    });

    final apiUrl = '${dotenv.env['URL']}api/groups/create';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'group_owner': _userId
      }),
    );

    setState(() {
      _loading = false;
    });

    if (response.statusCode == 201) {
      widget.onGroupCreated();
    } else {
      print('Erreur lors de la création du groupe : ${response.body}');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nom du groupe',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _loading || _userId == null ? null : _createGroup,
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Créer le groupe'),
        ),
      ],
    );
  }
}
