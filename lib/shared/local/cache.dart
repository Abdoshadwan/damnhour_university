import 'package:shared_preferences/shared_preferences.dart';

class Cache_Helper {
  static SharedPreferences? sharedpreferences;

  static Init() async {
    sharedpreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> putdata({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedpreferences?.setString(key, value);
    if (value is double) return await sharedpreferences?.setDouble(key, value);
    if (value is int) return await sharedpreferences?.setInt(key, value);

    return await sharedpreferences?.setBool(key, value);
  }

  static dynamic get_saved({required String key}) {
    return sharedpreferences?.get(key);
  }

  static int? get_saved_int({required String key}) {
    return sharedpreferences?.getInt(key);
  }

  static Future<bool?> removedata({required String key}) async {
    return await sharedpreferences?.remove(key);
  }
}
