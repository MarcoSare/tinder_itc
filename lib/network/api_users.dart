import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tinder_itc/models/user_model.dart';

class ApiUsers {
  static Future<List<UserModel>> getAllUsers(String idUser) async {
    String fileName = "userData.json";
    final Directory tempDir = await getTemporaryDirectory();
    File file = File("${tempDir.path}/$fileName");
    final dio = Dio();
    try {
      final response = await dio.get(
          'https://us-central1-tinder-itc.cloudfunctions.net/app/usuarios/$idUser');
      final data = response.data;
      file.writeAsStringSync(jsonEncode(data),
          flush: true, mode: FileMode.write);
      final listJSON = data as List;
      if (response.statusCode == 200) {
        return listJSON.map((map) => UserModel.fromMap(map)).toList();
      }
      return List.empty();
    } on Exception catch (e) {
      var jsonData = file.readAsStringSync();
      final data = jsonDecode(jsonData);
      final listJSON = data as List;
      //await Future.delayed(Duration(seconds: 1), () {});
      final users = listJSON.map((map) => UserModel.fromMap(map)).toList();
      return users;
    }
  }

  static Future<int> like(String idFrom, String idTo) async {
    final dio = Dio();
    try {
      Map<String, dynamic> requestBody = {
        'idTo': idTo,
      };
      final response = await dio.post(
          'https://us-central1-tinder-itc.cloudfunctions.net/app/usuarios/like/$idFrom',
          data: requestBody);

      if (response.statusCode == 200) {
        dynamic responseData = response.data;
        bool isMatch = responseData['isMatch'];
        if (isMatch) {
          return 1;
        }
        return 0;
      } else {
        return -1;
      }
    } on Exception catch (e) {
      return -1;
    }
  }
}
