import 'dart:io';

import 'package:flutter/material.dart';
import 'package:no_comment_flutter/models/Post.dart'; // Import modèle Post

class PostList extends StatelessWidget {
  final List<Post> posts;
  final Future<void> Function(int postId) onToggleLike;

  const PostList({
    super.key,
    required this.posts,
    required this.onToggleLike,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                if (post.localImagePath != null &&
                    File(post.localImagePath!).existsSync())
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(post.localImagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                  )
                else if (post.media != null && post.media!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        post.media!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                  ),
                Text(post.text ?? 'Pas de contenu',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 10),
                Text(
                    'Posté par ${post.username ?? 'Anonyme'} le ${post.datetime.toLocal()} en ${post.location ?? 'Inconnu'}',
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        print('Afficher les commentaires du post ${post.id}');
                      },
                      icon: const Icon(Icons.comment, color: Colors.white70),
                      label: const Text(
                        'Commentaire',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            (post.isLiked ?? false)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: (post.isLiked ?? false)
                                ? Colors.redAccent
                                : Colors.white70,
                          ),
                          onPressed: () async {
                            if (post.id != null) {
                              await onToggleLike(post.id!);
                            } else {
                              print('Post id is null, cannot toggle like');
                            }
                          },
                        ),
                        Text(
                          '${post.likesCount}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
