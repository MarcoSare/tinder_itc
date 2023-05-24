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

  static Future<UserModel?> getUsers(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('usuarios').doc(id).get();
    if (snapshot.exists) {
      return UserModel.fromFirestore(snapshot);
    } else {
      return null;
    }
  }

  static Future<bool> like(
      {required String idFrom, required String idTo}) async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(idFrom)
        .collection('yourLikes');
    await collectionRef.add({
      'idUser': idTo,
    });
    collectionRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(idTo)
        .collection('likes');
    await collectionRef.add({
      'idUser': idFrom,
    });

    print("Hola");
    return true;
  }
}
