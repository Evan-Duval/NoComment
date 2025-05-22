import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:no_comment_flutter/models/Post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostService {
  static Future<List<Post>> fetchPosts(
      String apiUrl, SharedPreferences prefs, int groupId) async {
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token non trouvé');

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
      throw Exception('Erreur récupération posts: ${response.statusCode}');
    }
  }

  static Future<int?> getCurrentUserId(SharedPreferences prefs) async {
    return prefs.getInt('id');
  }

  static Future<void> addLike(
      String apiUrl, SharedPreferences prefs, int postId) async {
    final token = prefs.getString('token');
    final userId = await getCurrentUserId(prefs);

    if (token == null || userId == null)
      throw Exception('Token ou userId non trouvé');

    final response = await http.post(
      Uri.parse('$apiUrl' 'api/likes/addLike'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'id_user': userId, 'id_post': postId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Erreur ajout like: ${response.statusCode}');
    }
  }

  static Future<void> removeLike(
      String apiUrl, SharedPreferences prefs, int postId) async {
    final token = prefs.getString('token');
    final userId = await getCurrentUserId(prefs);

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
      throw Exception('Erreur suppression like: ${response.statusCode}');
    }
  }
}
