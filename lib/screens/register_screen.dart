import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/screens/register_pages.dart';
import 'package:tinder_itc/widgets/alert_widget.dart';
import 'package:tinder_itc/widgets/date_picker_widget.dart';
import 'package:tinder_itc/widgets/gender_selector_widget.dart';
import 'package:tinder_itc/widgets/multi_select_chip_widget.dart';
import 'package:tinder_itc/widgets/text_email_widget.dart';
import 'package:tinder_itc/widgets/text_form_widget.dart';
import 'package:tinder_itc/widgets/text_pass_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  int _currentIndex = 0;
  int _finalIndex = 3;
  List<String?>? interests;
  TextEmailWidget textEmail = TextEmailWidget(
      'Correo', 'Ingresa tu correo', 'Ingresa un correo valido');
  TextPassWidget txtPass = TextPassWidget();

  TextFormWidget txtName = TextFormWidget('Nombre', 'Ingresa tu nombre',
      'Por favor, ingresa tu nombre', Icons.account_circle, 1, 20);
  TextFormWidget txtDescripcion = TextFormWidget.area(
      'Describete a tí mismo',
      'Cuentanos algo!',
      'Por favor, ingresa una descripción',
      Icons.handshake_outlined,
      1,
      250,
      5);
  MultiSelectChipWidget? multiSelectInter;
  DatePickerWidget birthdatePicker = DatePickerWidget(msgError: 'Selecciona una fecha porfavor...',);
  GenderSelectorWidget genderSelector = GenderSelectorWidget();

  late AlertWidget alertWidget;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    interests = [
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
    ];
    multiSelectInter = MultiSelectChipWidget(items: interests!);
    if(_auth.currentUser != null){ //Se entra aqui si se viene de algun proveedor de atenticación
      currentUser=_auth.currentUser!;
      _index.value=1;
    }
  }

  Widget _showPage() {
    switch (_index.value) {
      case 0:
        return RegisterPage1(
          txtEmail: textEmail,
          txtPass: txtPass,
          txtName: txtName,
        );
      case 1:
        return RegisterPage2(
          txtDescripcion: txtDescripcion,
          birthdatePicker: birthdatePicker,
          genderSelector: genderSelector,
        );
      case 2:
        return RegisterPage3(
          multiSelectorChip: multiSelectInter,
        );
      case 3:
        return const RegisterSuccess();
      default:
        return Container();
    }
  }

  Future<void> getScreenDataAndValidate() async {
    switch (_index.value) {
      case 0:
        if (textEmail.formKey.currentState!.validate() &&
            txtPass.formKey.currentState!.validate()) {
          final docUser = FirebaseFirestore.instance
              .collection("usuarios")
              .where("email", isEqualTo: textEmail.controlador);
          alertWidget.showProgress();
          final snapshot = await docUser.get();
          alertWidget.closeProgress();
          if (snapshot.size == 0) {
            _index.value++;
          } else {
            textEmail.error = true;
            textEmail.msgError = "Este correo ya está registrado";
            textEmail.formKey.currentState!.validate();
          }
        }
        break;

      case 1:
        if (txtDescripcion.formKey.currentState!.validate() && birthdatePicker.formKey.currentState!.validate()) {
          print(txtDescripcion.controlador +
              ' ' +
              RegisterPage2.selectedCareer.toString() +
              ' ' +
              RegisterPage2.selectedSemester.toString()+
              ' '+
              birthdatePicker.date.toString()+
              ' '+
              genderSelector.gender.toString());
          _index.value++;
        }
        break;

      case 2:
        if (multiSelectInter!.formKey.currentState!.validate()) {
          alertWidget.showProgress();
          (currentUser != null)? await createUserAuthProvider(): await createUser();
          alertWidget.closeProgress();
          _index.value++;
        }

        
      break;

    }
  }

  //ValueListenableBuilder para no usar setState? Se escucha el cambio de _currentIndex
  @override
  Widget build(BuildContext context) {
    alertWidget = AlertWidget(context: context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
              child: ValueListenableBuilder(
                valueListenable: _index,
                builder: (context, value, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LinearPercentIndicator(
                        percent: (value / _finalIndex) > 1 ||
                                (value / _finalIndex) < 0
                            ? 0
                            : (value / _finalIndex),
                        progressColor: const Color(0xFFD21D35),
                        lineHeight: 5,
                        animation: true,
                        animationDuration: 500,
                        animateFromLastPercent: true,
                        width: MediaQuery.of(context).size.width * 0.85,
                        alignment: MainAxisAlignment.center,
                      ),
                      _showPage(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: (_index.value == 3)
                            ? [
                                ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pushNamed(context, '/login'),
                                    child: const Text('Regresar al inicio'))
                              ]
                            : [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(20),
                                      shape: const CircleBorder(),
                                      backgroundColor: (_index.value == 0)
                                          ? Color.fromARGB(255, 237, 102, 92)
                                          : Colors.white),
                                  child: (_index.value == 0)
                                      ? const Icon(
                                          Icons.clear,
                                          size: 50,
                                        )
                                      : const Icon(
                                          Icons.arrow_back_ios_new,
                                          size: 50,
                                        ),
                                  onPressed: () {
                                    if (_index.value <= 0) {
                                      Navigator.pushNamed(context, '/login');
                                    }else if(_index.value==1 && currentUser != null){
                                      Fluttertoast.showToast(msg: 'Completa el registro por favor...', toastLength: Toast.LENGTH_LONG);
                                    }else{
                                      _index.value--;
                                    }
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(20),
                                      shape: const CircleBorder(),
                                      backgroundColor: (_index.value == 2)
                                          ? Color.fromARGB(255, 123, 230, 126)
                                          : Colors.white),
                                  child: (_index.value == 2)
                                      ? const Icon(Icons.check, size: 50)
                                      : const Icon(Icons.arrow_forward_ios,
                                          size: 50),
                                  onPressed: () {
                                    getScreenDataAndValidate();
                                  },
                                ),
                              ],
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            _currentIndex++;
          });
        },
        child: const Icon(Icons.arrow_forward_ios),
      ), */
    );
  }

  Future createUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: textEmail.controlador,
        password: txtPass.controlador,
      );


      String? urlImg = await uploadImg();
      final docUser = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid);
      final user = UserModel(
          name: txtName.controlador,
          email: textEmail.controlador,
          carrer: RegisterPage2.selectedCareer.toString(),
          semester: int.parse(RegisterPage2.selectedSemester.toString()),
          birthdate: birthdatePicker.date.toString(),
          gender: genderSelector.gender ? 'female': 'male',
          aboutMe: txtDescripcion.controlador,
          interests: multiSelectInter?.interestsList,
          profilePicture: urlImg);
      final userJson = user.toJson();
      
      await docUser.set(userJson).then((value) {
        userCredential.user!.sendEmailVerification();
      });

      

      print('Usuario registrado con éxito: ${userCredential.user!.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La contraseña es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        print('El correo electrónico ya está en uso.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future createUserAuthProvider() async {
    try{
      final docUser = FirebaseFirestore.instance.collection('usuarios').doc(currentUser!.uid);
      final user = UserModel(
        name: currentUser!.displayName,
        email: currentUser!.email,
        carrer: RegisterPage2.selectedCareer,
        semester: int.parse(RegisterPage2.selectedSemester.toString()),
        aboutMe: txtDescripcion.controlador,
        interests: multiSelectInter?.interestsList,
        birthdate: birthdatePicker.date.toString(),
        gender:genderSelector.gender ? 'female': 'male',
        profilePicture: currentUser!.photoURL
      );
      final userJSON = user.toJson();

      await docUser.set(userJSON).then((value) => print('usuario registrado con exito: ${currentUser!.uid}'));

    }on FirebaseAuthException catch (e){
      print(e.code);
    } catch (e){
      print (e);
    }
  }

  Future<dynamic> uploadImg() async {
    if (RegisterPage1.image != null) {
      try {
        File image = RegisterPage1.image;
        final storage = FirebaseStorage.instance;
        final storageRef = storage.ref();
        final imageRef =
            storageRef.child('images/${DateTime.now().toString()}');
        final uploadTask = imageRef.putFile(image);
        final snapshot = await uploadTask.whenComplete(() {});
        final imageUrl = await snapshot.ref.getDownloadURL();
        return imageUrl;
      } on Exception catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }
}
