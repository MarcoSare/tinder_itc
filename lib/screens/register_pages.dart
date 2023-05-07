import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:tinder_itc/widgets/text_email_widget.dart';
import 'package:tinder_itc/widgets/text_pass_widget.dart';

class RegisterPage1 extends StatefulWidget {
  RegisterPage1({super.key, this.onChangePage, this.txtEmail, this.txtPass});

  Function? onChangePage ;

  Widget? txtEmail;
  Widget? txtPass;
  static var image;


  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  

  TextPassWidget txtPass = TextPassWidget();

  bool _noImg=true;
  File? _path;

  final spaceH = SizedBox(height: 15);

  void _validate(){
    
  }

   void showBottomSheet() =>showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        )
    ), 
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
               if(_path!=null){
                _noImg=false;
               }
              });
            }));
          }),
        ),
        ListTile(
          leading: const Icon(Icons.camera),
          title: const Text('Tomar foto'),
          onTap: (() {
            takePictureCamera().then((value){
              Navigator.pop(context);
              if(_path!=null){
                _noImg=false;
              }
            });
          }),
        )
      ],
    )
  );

  Future pickImageGallery() async {
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return ;
      final tempPath = File(image.path);
      setState(() { _path=tempPath; RegisterPage1.image=tempPath;});
    } on PlatformException catch(e){
      print('failed $e');
    }
  }
  
  Future takePictureCamera() async {
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return ;
      final tempPath = File(image.path);
      setState(() { _path=tempPath; RegisterPage1.image=tempPath;});
    } on PlatformException catch(e){
      print('failed $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text('Elige una foto!',
              style:TextStyle(
                fontSize: 20
              )
            ),
          ),
          GestureDetector(
            onTap: (() {
              showBottomSheet();
            }),
            child:_noImg? 
              const CircleAvatar(
                backgroundImage: AssetImage('assets/no_image.jpg'),
                backgroundColor: Colors.transparent,
                radius: 55,
              ):
              CircleAvatar(
                backgroundImage: FileImage(_path!),
                backgroundColor: Colors.transparent,
                radius: 55,
              )
          ),
          widget.txtEmail!,
          widget.txtPass!,
        ],
      ),
    );
  }
}

class RegisterPage2 extends StatefulWidget {
  RegisterPage2({super.key, this.txtDescripcion, this.onChangeCareer});

  Widget? txtDescripcion;
  Function(String)? onChangeCareer;

  static var selectedCareer;
  static var selectedSemester;

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {

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

    List<int> semesters = [
      1,2,3,4,5,6,7,8,9,10,11,12
    ];

    String? first;
    int? firstSemester;

  @override
  void initState() {
    super.initState();
    first=careers.first;
    firstSemester=semesters.first;
    RegisterPage2.selectedCareer=first;
    RegisterPage2.selectedSemester=firstSemester;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Elige tu carrera:',
            style: TextStyle(
              fontSize: 20
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Center(
              child: StatefulBuilder(
                builder: (context, setState){
                  return DropdownButton(
                    value: first,
                    items: careers.map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value)
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        RegisterPage2.selectedCareer=value;
                        first=value!;
                      });
                    },
                  );
                } 
              )
            ),
          ),
          const Text('Elige tu semestre:',
            style: TextStyle(
              fontSize: 20
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return DropdownButton(
                    value: firstSemester,
                    items: semesters.map<DropdownMenuItem<int>>((int value){
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value.toString())
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        RegisterPage2.selectedSemester=value;
                        firstSemester=value!;
                      });
                    },
                  );
                }
              ),
            ),
          ),
          const Text('¡Cuentale a la gente sobre tí!',
            style: TextStyle(
              fontSize: 20
            ),
          ),
          widget.txtDescripcion!,
        ],
      ),
    );
  }
}

class RegisterPage3 extends StatefulWidget {
  RegisterPage3({super.key, this.multiSelectorChip});

  Widget? multiSelectorChip;

  @override
  State<RegisterPage3> createState() => _RegisterPage3State();
}

class _RegisterPage3State extends State<RegisterPage3> {

  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset('assets/animation/interests.json', width: 250, height: 250,),
          Padding(
            padding: const EdgeInsets.fromLTRB(10,0,10,20),
            child: widget.multiSelectorChip!
          )
        ],
      )
      
    );
  }
}

class RegisterSuccess extends StatelessWidget {
  const RegisterSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LottieBuilder.asset('assets/animation/successful.json',repeat: true),
        const Text('Tu cuenta ha sido creada exitosamente, sigue los pasos de validación en tu correo.', style: TextStyle(fontSize: 30), textAlign: TextAlign.center,)
      ],
    );
  }
}