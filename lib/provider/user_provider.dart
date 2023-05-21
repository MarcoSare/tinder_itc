import 'package:flutter/material.dart';
import 'package:tinder_itc/models/user_model.dart';

class UserProvider with ChangeNotifier{
  
  UserModel? user;

  setUserData(UserModel user){
    this.user=user;
    notifyListeners();
  }

  getUserData() => this.user;

}