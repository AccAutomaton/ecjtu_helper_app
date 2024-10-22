import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveStringData(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<void> saveStringDatas(Map<String, String> map) async {
  final prefs = await SharedPreferences.getInstance();
  map.forEach((key, value) async {
    await prefs.setString(key, value);
  });
}

Future<String?> readStringData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<void> saveIntData(String key, int value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key, value);
}

Future<int?> readIntData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}