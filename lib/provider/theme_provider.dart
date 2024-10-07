import 'package:flutter/material.dart';

import '../utils/shared_preferences_util.dart';

class ThemeProvider with ChangeNotifier {
  static final ThemeProvider themeProvider = ThemeProvider();

  ThemeMode themeMode = ThemeMode.system;

  static ThemeProvider get() {
    return themeProvider;
  }

  Future<void> init() async {
    String? darkModeStringInt = await readData("application_dark_mode");
    if (darkModeStringInt != null) {
      int darkMode = int.parse(darkModeStringInt);
      themeMode = darkModeMap[darkMode]!;
      notifyListeners();
    }
  }

  setThemeMode(ThemeMode mode) async {
    late String themeModeInt;
    switch (mode) {
      case ThemeMode.light:
        themeModeInt = "0";
        break;
      case ThemeMode.dark:
        themeModeInt = "1";
        break;
      default:
        themeModeInt = "2";
        break;
    }
    await saveData("application_dark_mode", themeModeInt);
    themeMode = mode;
    notifyListeners();
  }}

const Map<int, ThemeMode> darkModeMap = {
  0: ThemeMode.light,
  1: ThemeMode.dark,
  2: ThemeMode.system,
};