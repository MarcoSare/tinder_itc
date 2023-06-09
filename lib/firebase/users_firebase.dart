import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tinder_itc/models/filter_model.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/network/api_users.dart';

class UsersFireBase {
  static Future<List<UserModel>> getAllUsers() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('usuarios').get();
    List<UserModel> userList =
        snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    return userList;
  }

  static Future<UserModel?> getUsers(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('usuarios').doc(id).get();
    if (snapshot.exists) {
      return UserModel.fromFirestore(snapshot);
    } else {
      return null;
    }
  }

  static Future<int> like(
      {required String idFrom, required UserModel toUser}) async {
    try {
      final docUser = FirebaseFirestore.instance
          .collection("usuarios")
          .doc(idFrom)
          .collection("yourLikes")
          .where("idUser", isEqualTo: toUser.id);
      final snapshot = await docUser.get();

      if (snapshot.size <= 0) {
        CollectionReference collectionRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(idFrom)
            .collection('yourLikes');
        await collectionRef.add({
          'idUser': toUser.id,
        });
        collectionRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(toUser.id)
            .collection('likes');
        await collectionRef.add({
          'idUser': idFrom,
        });
        if (toUser.tokenDevice != null) {
          await sendNoti(data: {
            'to': toUser.tokenDevice,
            'notification': {
              'body': 'Has recibido un like',
              'OrganizationId': '2',
              "content_available": true,
              "priority": "high",
              "subtitle": "Revisa tu perfil ahora",
              "title": "Nuevo like"
            },
          });
          int response = await ApiUsers.like(idFrom, toUser.id!);
          return response;
        } else {
          int response = await ApiUsers.like(idFrom, toUser.id!);
          return response;
        }
      } else {
        return 2;
      }
    } on Exception catch (e) {
      return -1;
    }
  }

  static Future<void> sendNoti({required Map<String, dynamic> data}) async {
    final dio = Dio();

    Map<String, dynamic> headers = {
      'Authorization':
          'key=AAAAEYI9mCc:APA91bGk4YeSGchJr9Utj9B4Eq2KlA2O87zMndeUXDWTGaubfGAdFxyGSXD1oKHRO_68yTdcu9qPkQJlGdxHZscRkSn1o9l2Kow9DFYPM5Da-m2om_ccxVOj17GEfbvRS61rFg1kyM4N',
      'Content-Type': 'application/json',
    };
    try {
      Response response = await dio.post(
        'https://fcm.googleapis.com/fcm/send',
        data: data,
        options: Options(headers: headers),
      );
      print('Respuesta: ${response.data}');
    } catch (error) {
      print('Error: $error');
    }
  }

  static Future<FilterModel> getFilters({required String id}) async {
    String fileName = "filters.json";
    final Directory tempDir = await getTemporaryDirectory();
    File file = File("${tempDir.path}/$fileName");
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(id)
          .collection('filters')
          .get();
      FilterModel filters = FilterModel.fromFirestore(snapshot.docs[0]);
      file.writeAsStringSync(jsonEncode(filters.toJson()),
          flush: true, mode: FileMode.write);
      return filters;
    } on Exception catch (e) {
      var jsonData = file.readAsStringSync();
      final data = jsonDecode(jsonData);
      return FilterModel.fromMap(data);
    }
  }

  static Future<bool> setFilters(
      {required FilterModel filter, required String idUser}) async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(idUser)
          .collection('filters')
          .doc(filter.id)
          .update({
        'ages': filter.ages,
        'carrer': filter.carrer,
        'gender': filter.gender
      });
      return true;
    } on Exception catch (e) {
      print("error");
      return false;
    }
  }

  static Future<bool> createFilters(
      {required FilterModel filter, required String idUser}) async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(idUser)
          .collection('filters')
          .doc(filter.id)
          .set({
        'ages': filter.ages,
        'carrer': filter.carrer,
        'gender': filter.gender
      });
      return true;
    } on Exception catch (e) {
      print("error");
      return false;
    }
  }
}
