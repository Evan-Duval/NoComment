import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupService {
  static Future<bool> checkIfFollowing(
      String apiUrl, SharedPreferences prefs, int groupId) async {
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token non trouvé');

    final response = await http.get(
      Uri.parse('$apiUrl' 'api/groups/$groupId/follow-status'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['is_following'] ?? false;
    } else {
      throw Exception('Erreur API status follow: ${response.statusCode}');
    }
  }

  static Future<bool> toggleFollow(
      String apiUrl, SharedPreferences prefs, int groupId) async {
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token non trouvé');

    final response = await http.post(
      Uri.parse('$apiUrl' 'api/groups/$groupId/toggle-follow'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['following'] ?? false;
    } else {
      throw Exception('Erreur API toggle follow: ${response.statusCode}');
    }
  }
}
