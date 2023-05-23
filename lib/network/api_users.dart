import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tinder_itc/models/user_model.dart';

class ApiUsers {
  static Future<List<UserModel>> getAllUsers() async {
    String fileName = "userData.json";
    final Directory tempDir = await getTemporaryDirectory();
    File file = new File(tempDir.path + "/" + fileName);
    final dio = Dio();
    try {
      final response = await dio.get(
          'https://us-central1-tinder-itc.cloudfunctions.net/app/usuarios');
      final data = response.data;
      file.writeAsStringSync(jsonEncode(data),
          flush: true, mode: FileMode.write);
      final listJSON = data as List;
      if (response.statusCode == 200) {
        return listJSON.map((map) => UserModel.fromMap(map)).toList();
      }
      return List.empty();
    } on Exception catch (e) {
      print("loading from cache");
      var jsonData = file.readAsStringSync();
      final data = jsonDecode(jsonData);
      final listJSON = data as List;
      return listJSON.map((map) => UserModel.fromMap(map)).toList();
    }
  }
}
