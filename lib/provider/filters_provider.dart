import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/network/api_users.dart';

class FiltersProvider with ChangeNotifier {
  List<UserModel> listUsers = List.empty(growable: true);

  List<UserModel> get list => listUsers;

  setFilter(List<UserModel> list) {
    listUsers = list;
    notifyListeners();
  }

  Future<void> getFilter(String idFrom) async {
    listUsers = await ApiUsers.getAllUsers(idFrom);
    notifyListeners();
  }
}
