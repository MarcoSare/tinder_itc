import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
    static bool _firstTimeOpen = true;

    static late SharedPreferences _appPrefs;

    static Future preferences() async {
      _appPrefs=await SharedPreferences.getInstance();
    }

    static set firstTimeOpen(bool firstTimeOpen){
      _firstTimeOpen=firstTimeOpen;
      _appPrefs.setBool('firstTimeOpen', firstTimeOpen);
    }

    static bool get firstTimeOpen => _appPrefs.getBool('firstTimeOpen') ?? _firstTimeOpen;

    static clearAppPrefs(){
      _appPrefs.clear();
      _firstTimeOpen=true;
    }
}