import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_itc/models/user_model.dart';

class UsersFireBase {
  static Future<List<UserModel>> getAllUsers() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('usuarios').get();
    List<UserModel> userList =
        snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    return userList;
  }
}
