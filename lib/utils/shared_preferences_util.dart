import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveData(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<void> saveDatas(Map<String, String> map) async {
  final prefs = await SharedPreferences.getInstance();
  map.forEach((key, value) async {
    await prefs.setString(key, value);
  });
}

Future<String?> readData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}
