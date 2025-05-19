import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:no_comment_flutter/config/config.dart';
import 'package:no_comment_flutter/models/Post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:no_comment_flutter/pages/groupes/CreatePost.dart';

class GroupContent extends StatefulWidget {
  final Map<String, dynamic> group;

  const GroupContent({super.key, required this.group});

  @override
  State<GroupContent> createState() => _GroupContentState();
}

class _GroupContentState extends State<GroupContent> {
  bool isFollowing = false;
  bool isLoading = true;
  bool isLoadingPosts = true;
  List<Post> posts = [];

  late String apiUrl;

  @override
  void initState() {
    super.initState();
    apiUrl = dotenv.env['URL'] ?? '';
    if (apiUrl.endsWith('/')) {
      apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    }
    _checkIfFollowing();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => isLoadingPosts = true);
    try {
      final fetchedPosts = await _fetchPosts(widget.group['id_group']);
      setState(() {
        posts = fetchedPosts;
        isLoadingPosts = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des posts: $e');
      setState(() => isLoadingPosts = false);
    }
  }

  Future<void> _checkIfFollowing() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.get(
        Uri.parse(
            '$apiUrl/api/groups/${widget.group['id_group']}/follow-status'),
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
        throw Exception('Erreur API status follow: ${response.statusCode}');
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

      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final response = await http.post(
        Uri.parse(
            '$apiUrl/api/groups/${widget.group['id_group']}/toggle-follow'),
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
        throw Exception('Erreur API toggle follow: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur _toggleFollow: $e');
      setState(() => isLoading = false);
    }
  }

  Future<List<Post>> _fetchPosts(int groupId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token non trouvé');
      }

      // Correction de l'URL
      final response = await http.get(
        Uri.parse('$apiUrl/api/posts/getByGroup/$groupId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> postData = jsonDecode(response.body);
        return postData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception(
            'Erreur lors de la récupération des posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur _fetchPosts: $e');
      return [];
    }
  }

  // Fonction pour vérifier si un fichier existe sans provoquer d'erreur
  bool fileExists(String? path) {
    if (kIsWeb)
      return false; // Sur le Web, on ne peut pas vérifier les fichiers locaux
    if (path == null || path.isEmpty) return false;
    try {
      return File(path).existsSync();
    } catch (e) {
      print('Erreur lors de la vérification du fichier: $e');
      return false;
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
      body: isLoadingPosts
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : posts.isEmpty
              ? const Center(
                  child: Text(
                    'Aucun post disponible dans ce groupe',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPosts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        color: const Color(0xFF1C2833),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.title ?? 'Sans titre',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              if (!kIsWeb &&
                                  post.localImagePath != null &&
                                  fileExists(post.localImagePath))
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(post.localImagePath!),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print(
                                            'Erreur d\'affichage de l\'image locale: $error');
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            'Erreur de chargement de l\'image locale',
                                            style: TextStyle(
                                                color: Colors.redAccent),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              else if (post.imageUrl != null &&
                                  post.imageUrl!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      post.imageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print(
                                            'Erreur d\'affichage de l\'image distante: $error');
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            'Erreur de chargement de l\'image',
                                            style: TextStyle(
                                                color: Colors.redAccent),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              Text(post.text ?? 'Pas de contenu',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 16)),
                              const SizedBox(height: 10),
                              Text(
                                  'Posté par ${post.userName ?? 'Anonyme'} le ${post.dateTime.toLocal()}',
                                  style: const TextStyle(
                                      color: Colors.white38, fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: isFollowing
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CreatePost(groupId: widget.group['id_group']),
                  ),
                ).then((_) {
                  _loadPosts(); // Recharger les posts après ajout
                });
              },
              backgroundColor: Config.colors.primaryColor,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
