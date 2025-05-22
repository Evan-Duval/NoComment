import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:no_comment_flutter/config/config.dart';
import 'package:no_comment_flutter/models/Post.dart';
import 'package:no_comment_flutter/pages/groupes/CreatePost.dart';
import 'package:no_comment_flutter/widget/post_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GroupService.dart';
import 'PostService.dart';

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

  late SharedPreferences prefs;
  late String apiUrl;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    prefs = await SharedPreferences.getInstance();
    apiUrl = dotenv.env['URL'] ?? '';

    setState(() => isLoading = true);
    try {
      isFollowing = await GroupService.checkIfFollowing(
          apiUrl, prefs, widget.group['id_group']);
      posts =
          await PostService.fetchPosts(apiUrl, prefs, widget.group['id_group']);
    } catch (e) {
      print('Erreur init: $e');
    }
    setState(() {
      isLoading = false;
      isLoadingPosts = false;
    });
  }

  Future<void> _loadPosts() async {
    setState(() => isLoadingPosts = true);
    try {
      posts =
          await PostService.fetchPosts(apiUrl, prefs, widget.group['id_group']);
    } catch (e) {
      print('Erreur lors du chargement des posts: $e');
    }
    setState(() => isLoadingPosts = false);
  }

  Future<void> _toggleFollow() async {
    setState(() => isLoading = true);
    try {
      isFollowing = await GroupService.toggleFollow(
          apiUrl, prefs, widget.group['id_group']);
    } catch (e) {
      print('Erreur _toggleFollow: $e');
    }
    setState(() => isLoading = false);
  }

  Future<void> _toggleLike(int postId) async {
    try {
      final index = posts.indexWhere((p) => p.id == postId);
      if (index == -1) return;

      final post = posts[index];
      final currentlyLiked = post.isLiked ?? false;

      setState(() {
        posts[index] = post.copyWith(
          isLiked: !currentlyLiked,
          likesCount: currentlyLiked
              ? (post.likesCount != null ? post.likesCount! - 1 : 0)
              : (post.likesCount != null ? post.likesCount! + 1 : 1),
        );
      });

      if (currentlyLiked) {
        await PostService.removeLike(apiUrl, prefs, postId);
      } else {
        await PostService.addLike(apiUrl, prefs, postId);
      }
    } catch (e) {
      print('Erreur _toggleLike: $e');
      await _loadPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.colors.backgroundColor,
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
