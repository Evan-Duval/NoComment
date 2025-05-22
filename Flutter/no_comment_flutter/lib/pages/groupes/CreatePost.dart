import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:no_comment_flutter/config/config.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class CreatePost extends StatefulWidget {
  final int groupId;

  const CreatePost({super.key, required this.groupId});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  final loc.Location location = loc.Location();
  double? latitude;
  double? longitude;
  String? country;
  String? administrativeArea;
  String? city;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Service de localisation désactivé')),
          );
          return;
        }
      }

      loc.PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission de localisation refusée')),
          );
          return;
        }
      }

      final locationData = await location.getLocation();
      setState(() {
        latitude = locationData.latitude;
        longitude = locationData.longitude;
      });

      if (latitude != null && longitude != null) {
        try {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(latitude!, longitude!);
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            setState(() {
              country = place.country;
              administrativeArea = place.administrativeArea;
              city = place.locality;
            });
          }
        } catch (e) {
          print('Erreur lors de la récupération des données géographiques: $e');
        }
      }

      print('Localisation récupérée : $latitude, $longitude');
      print('Pays : $country');
      print('Département : $administrativeArea');
      print('Ville : $city');
    } catch (e) {
      print('Erreur localisation : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de localisation: $e')),
      );
    }
    await Supabase.initialize(
      url: 'https://cblssbvfgxtadeevsldy.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNibHNzYnZmZ3h0YWRlZXZzbGR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NDE3MzMsImV4cCI6MjA2MzMxNzczM30.6vfHowlW_UT2jeO1MdaqlB6lWWd3qloqppOAsUCD3Ts',
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(pickedFile.path);
      final String savedPath = '${directory.path}/$fileName';

      final savedImage = await File(pickedFile.path).copy(savedPath);

      setState(() {
        _imageFile = savedImage;
      });
    } catch (e) {
      print('Erreur lors de la prise de photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la prise de photo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.colors.backgroundColor,
        title: Text(
          'Créer un post',
          style: TextStyle(
            color: Config.colors.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: Config.colors.second_backgroundColor,
        ),
      ),
      backgroundColor: Config.colors.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Titre',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un titre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Contenu',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le contenu du post';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _pickImageFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text(
                        'Prendre une photo',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    if (_imageFile != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Image.file(_imageFile!, height: 200),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _imageFile = null;
                                });
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text('Supprimer l\'image'),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Config.colors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Publier le post',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 20),
                    if (city != null ||
                        administrativeArea != null ||
                        country != null)
                      Text(
                        'Localisation: ${city ?? ''}, ${administrativeArea ?? ''}, ${country ?? ''}',
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Récupération des données
      final title = _titleController.text.trim();
      final text = _textController.text.trim();
      final datetime = DateTime.now().toIso8601String();

      // Récupération des infos utilisateur
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('id');
      final token = prefs.getString('token');
      final apiUrl = dotenv.env['URL'];

      if (userId == null || token == null || apiUrl == null || apiUrl.isEmpty) {
        throw Exception('ID, token ou URL manquant');
      }

      // Création de la requête
      final uri = Uri.parse('${apiUrl}api/posts/create');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['title'] = title;
      request.fields['text'] = text;
      request.fields['id_group'] = widget.groupId.toString();
      request.fields['id_user'] = userId.toString();
      request.fields['datetime'] = datetime;
      request.fields['location'] = administrativeArea ?? 'Inconnue';

      Future<String?> _uploadImageToSupabase(File imageFile) async {
        try {
          final supabase = Supabase.instance.client;

          final fileBytes = await imageFile.readAsBytes();
          final fileName = 'post_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final filePath = '/$fileName';

          final response = await supabase.storage
              .from('nocomment')
              .uploadBinary(filePath, fileBytes,
                  fileOptions: const FileOptions(
                    contentType: 'image/jpeg',
                    upsert: true,
                  ));

          if (response.isEmpty) {
            throw Exception('Erreur lors de l\'upload');
          }

          // Récupère l'URL publique
          final publicUrl =
              supabase.storage.from('nocomment').getPublicUrl(filePath);
          return publicUrl;
        } catch (e) {
          print('Erreur upload Supabase: $e');
          return null;
        }
      }

      // Ajout de l'image si présente
      if (_imageFile != null && await _imageFile!.exists()) {
        final imageUrl = await _uploadImageToSupabase(_imageFile!);
        if (imageUrl != null) {
          request.fields['media'] = imageUrl;
        } else {
          throw Exception('Échec de l\'upload de l\'image');
        }
      }

      // Envoi de la requête
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post créé avec succès')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Erreur ${response.statusCode} : ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
