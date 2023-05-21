import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? pass;
  String? profilePicture;
  String? carrer;
  int? semester;
  String? aboutMe;
  List<String?>? interests;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.pass,
      this.profilePicture,
      this.carrer,
      this.semester,
      this.aboutMe,
      this.interests});

  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      pass: map['pass'],
      profilePicture: map['profile_picture'],
      carrer: map['carrer'],
      semester: map['semester'],
      aboutMe: map['aboutMe'],
      interests: List<String?>.from(map['interests']),
    );
  }

  static String toMap(UserModel user){
    return json.encode(user);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'pass': pass,
        'profile_picture': profilePicture,
        'carrer': carrer,
        'semester': semester,
        'aboutMe': aboutMe,
        'interests': interests
      };
}
