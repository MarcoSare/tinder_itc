import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/widgets/alert_widget.dart';
import 'package:tinder_itc/widgets/multi_select_chip_widget.dart';
import 'package:tinder_itc/widgets/text_form_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  UpdateProfileScreen({super.key});

  var image;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool _noImg = true;
  File? _path;
  var imgProvider;

  TextFormWidget txtNombre = TextFormWidget('Nombre', 'Ingresa tu nombre',
      'Llena este campo porfavor...', Icons.draw, 1, 500);
  TextFormWidget txtDesc = TextFormWidget.area(
      'Descripción',
      'Cuentale a la gente de ti',
      'Llena este campo....',
      Icons.draw,
      1,
      500,
      2);
  MultiSelectChipWidget? interestSelector;

  List<String> careers = [
    'Ing. Sistemas Computacionales',
    'Ing. Mecatrónica',
    'Lic. Administración de Empresas',
    'Ing. Gestión Emprearial',
    'Ing. Bioquímica',
    'Ing. Qímica ',
    'Ing. Ambiental',
    'Ing. Industrial',
    'Ing. Mecánica'
  ];

  List<int> semesters = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  String? first;
  int? firstSemester;
  var selectedCareer;
  var selectedSemester;

  void showBottomSheet() => showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image_search),
                title: const Text('Escoger de galería'),
                onTap: (() {
                  pickImageGallery().then(((value) {
                    Navigator.pop(context);
                    setState(() {
                      if (_path != null) {
                        _noImg = false;
                      }
                    });
                  }));
                }),
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Tomar foto'),
                onTap: (() {
                  takePictureCamera().then((value) {
                    Navigator.pop(context);
                    setState(() {
                      if (_path != null) {
                        _noImg = false;
                      }
                    });
                  });
                }),
              )
            ],
          ));

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final tempPath = File(image.path);
      setState(() {
        _path = tempPath;
      });
    } on PlatformException catch (e) {
      print('failed $e');
    }
  }

  Future takePictureCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final tempPath = File(image.path);
      setState(() {
        _path = tempPath;
      });
    } on PlatformException catch (e) {
      print('failed $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    interestSelector = MultiSelectChipWidget(items: const [
      'cafe',
      'fiesta',
      'estudio',
      'comida',
      'películas',
      'deporte',
      'tv',
      'novelas',
      'musica',
      'pareja',
      'amigos',
      'casual',
      'cena',
      'gracioso',
      'libros',
      'netflix',
      'atardecer'
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel userModel = userProvider.getUserData() ?? UserModel();

    first = userModel.carrer ?? 'Ing. Sistemas Computacionales';
    firstSemester = userModel.semester ?? 1;
    txtNombre.controlador = userModel.name ?? 'no_name';
    txtDesc.controlador = userModel.aboutMe ?? 'no_desc';
    interestSelector!.initialValues = userModel.interests ?? [''];
    widget.image = userModel.profilePicture ?? 'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';

    final dropCareer = StatefulBuilder(
      builder: (context, setState) {
        return DropdownButton(
          value: first,
          items: careers.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCareer = value;
              first = value!;
            });
          },
        );
      },
    );

    final dropSemester = StatefulBuilder(
      builder: (context, setState) {
        return DropdownButton(
          value: firstSemester,
          items: semesters.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem(
                value: value, child: Text(value.toString()));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedSemester = value;
              firstSemester = value!;
            });
          },

        );
      },
    );

    final btnUpdate = ElevatedButton(onPressed: () async{
      await updateUser(userProvider);
    },
    child: const Text('Actualizar perfil'));

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child:
                      Text('Elige una foto!', style: TextStyle(fontSize: 20)),
                ),
                GestureDetector(
                    onTap: (() {
                      UserInfo authProv =
                          FirebaseAuth.instance.currentUser!.providerData[0];
                      if (authProv.providerId != 'password') {
                        AlertWidget.showMessage(context, 'Error',
                            'No puedes actualizar tu foto de perfil a menos que hayas iniciado sesión con tu correo y contraseña...');
                      } else {
                        showBottomSheet();
                      }
                    }),
                    child: _path == null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(widget.image),
                            backgroundColor: Colors.transparent,
                            radius: 55,
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(_path!),
                            backgroundColor: Colors.transparent,
                            radius: 55,
                          )),
                txtNombre,
                txtDesc,
                interestSelector!,
                dropCareer,
                dropSemester,
                btnUpdate,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future updateUser(UserProvider userProvider) async{
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final email = FirebaseAuth.instance.currentUser!.email;
      final docUser = FirebaseFirestore.instance.collection('usuarios').doc(uid);
      final resultImg = await updatePicture();
      UserModel userData;
      userData = UserModel(
          name: txtNombre.controlador,
          carrer: selectedCareer ?? first,
          email: email,
          semester: selectedSemester ?? firstSemester,
          aboutMe: txtDesc.controlador,
          interests: interestSelector!.interestsList.isEmpty ? interestSelector!.initialValues: interestSelector!.interestsList,
          profilePicture: resultImg != false ? resultImg : widget.image
        );
      final userJSON = userData.toJson();

      await docUser.update(userJSON).then((value) => userProvider.setUserData(userData));

      print('actualizao');

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> updatePicture() async{
    if(_path!=null){
      try {
        File img = _path!;
        final storage = FirebaseStorage.instance;
        final storageRef = storage.ref();
        final imageRef =
            storageRef.child('images/${DateTime.now().toString()}');
        final uploadTask = imageRef.putFile(img);
        final snapshot = await uploadTask.whenComplete(() {});
        final imageUrl = await snapshot.ref.getDownloadURL();
        return imageUrl;
      } catch (e) {
        return false;
      }
    }else{
      return false;
    }
  }

}
