import 'package:cloud_firestore/cloud_firestore.dart';

class FilterModel {
  String? id;
  String? carrer;
  String? gender;
  dynamic ages;

  FilterModel({this.carrer, this.gender, this.ages, this.id});

  factory FilterModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return FilterModel(
        carrer: map['carrer'],
        gender: map['gender'],
        ages: map['ages'],
        id: doc.id);
  }

  factory FilterModel.fromMap(Map<String, dynamic> map) {
    return FilterModel(
        carrer: map['carrer'],
        gender: map['gender'],
        ages: map['ages'],
        id: map['id']);
  }

  Map<String, dynamic> toJson() =>
      {'carrer': carrer, 'gender': gender, 'ages': ages, 'id': id};
}
