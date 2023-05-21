import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePictureProvider with ChangeNotifier {

  File? img;

  setPictureData(File image){
    img=image;
    notifyListeners();
  }

  getPictureData() => this.img;

}