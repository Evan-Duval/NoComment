import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<String?> getToken(SharedPreferences prefs) async {
    return prefs.getString('token');
  }

  static Future<int?> getUserId(SharedPreferences prefs) async {
    return prefs.getInt('id');
  }
}
