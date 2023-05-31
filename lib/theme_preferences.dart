import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  Future<void> setTheme(bool theme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('theme', theme); //true=> oscuro, false =>claro
  }

  Future<bool?> getTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('theme');
  }
}
