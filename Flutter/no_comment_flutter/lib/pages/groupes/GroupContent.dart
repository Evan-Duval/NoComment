import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:no_comment_flutter/config/config.dart';
import 'package:no_comment_flutter/models/Post.dart';
import 'package:no_comment_flutter/pages/groupes/CreatePost.dart';
import 'package:no_comment_flutter/widget/post_list.dart';
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
  bool isLoadingPosts = true;
  List<Post> posts = [];

  late String apiUrl;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {});
    apiUrl = dotenv.env['URL'] ?? '';
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

      final response = await http.get(
        Uri.parse('$apiUrl' 'api/posts/getByGroup/$groupId'),
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

  // Récupère l'id de l'utilisateur depuis SharedPreferences
  Future<int?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  Future<void> _addLike(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = await _getCurrentUserId();

    if (token == null || userId == null)
      throw Exception('Token ou userId non trouvé');

    final response = await http.post(
      Uri.parse('$apiUrl' 'api/likes/addLike'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_user': userId,
        'id_post': postId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Erreur lors de l\'ajout du like: ${response.statusCode}');
    }
  }

  Future<void> _removeLike(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = await _getCurrentUserId();

    if (token == null || userId == null)
      throw Exception('Token ou userId non trouvé');

    final response = await http.delete(
      Uri.parse('$apiUrl' 'api/likes/removePostLike/$postId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'id_user': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Erreur lors de la suppression du like: ${response.statusCode}');
    }
  }

  Future<void> _toggleLike(int postId) async {
    try {
      final index = posts.indexWhere((p) => p.id == postId);
      if (index == -1) return;

      final post = posts[index];
      final currentlyLiked = post.isLiked ?? false;

      // Mise à jour locale immédiate
      setState(() {
        posts[index] = post.copyWith(
          isLiked: !currentlyLiked,
          likesCount: currentlyLiked
              ? (post.likesCount != null ? post.likesCount! - 1 : 0)
              : (post.likesCount != null ? post.likesCount! + 1 : 1),
        );
      });

      // Envoi requête réseau
      if (currentlyLiked) {
        await _removeLike(postId);
      } else {
        await _addLike(postId);
      }
    } catch (e) {
      print('Erreur _toggleLike: $e');

      // En cas d’erreur, reload les posts (ou revert localement)
      await _loadPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17202A),
      appBar: AppBar(
        title: Text(widget.group['name'] ?? 'Groupe'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Config.colors.second_backgroundColor,
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
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? const Center(
                  child: Text(
                    'Aucun post disponible dans ce groupe',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPosts,
                  child: PostList(
                    posts: posts,
                    onToggleLike: (postId) async {
                      await _toggleLike(postId);
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
                ).then((_) => _loadPosts());
              },
              backgroundColor: Config.colors.primaryColor,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
