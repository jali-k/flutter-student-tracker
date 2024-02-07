

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil{
  static const String userKey = "user";
  static final SharedPreferences _sharedPreference = SharedPreferences.getInstance() as SharedPreferences;

  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _sharedPreference.setString(userKey, user.toString());
  }


}