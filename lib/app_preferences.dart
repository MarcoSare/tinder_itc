import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static bool _firstTimeOpen = true;
  static String token = "";

  static late SharedPreferences _appPrefs;

  static Future preferences() async {
    _appPrefs = await SharedPreferences.getInstance();
  }

  static set firstTimeOpen(bool firstTimeOpen) {
    _firstTimeOpen = firstTimeOpen;
    _appPrefs.setBool('firstTimeOpen', firstTimeOpen);
  }

  static bool get firstTimeOpen =>
      _appPrefs.getBool('firstTimeOpen') ?? _firstTimeOpen;

  static set tokenDivice(String divice) {
    token = divice;
    _appPrefs.setString('token', divice);
  }

  static String get tokenDivice => _appPrefs.getString('token') ?? token;

  static clearAppPrefs() {
    _appPrefs.clear();
    _firstTimeOpen = true;
  }
}
