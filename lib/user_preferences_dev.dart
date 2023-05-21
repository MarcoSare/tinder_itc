import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_itc/models/user_model.dart';

class UserPreferencesDev {
  static String _user = '["no_user"]';

  static late SharedPreferences _userPrefs;

  static Future preferences() async {
    _userPrefs = await SharedPreferences.getInstance();
  }

  static set user(String user){
    _user=user;
    _userPrefs.setString('user', user);
  }

  static String get user{
    return _userPrefs.getString('user') ?? _user;
  }

  static clearPrefs(){
    _userPrefs.clear();
    _user='["no_user"]';
  }

  static UserModel getUserObject(){
    if(UserPreferencesDev.user!='["no_user"]'){
      final userData = json.decode(UserPreferencesDev.user);
      return UserModel.fromMap(userData);
    } return UserModel();
  }

}