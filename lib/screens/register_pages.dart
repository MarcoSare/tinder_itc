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
  RegisterPage1(
      {super.key,
      this.onChangePage,
      this.txtEmail,
      this.txtPass,
      this.txtName});

  Function? onChangePage;
  Widget? txtName;
  Widget? txtEmail;
  Widget? txtPass;

  static var image;

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  TextPassWidget txtPass = TextPassWidget();

  bool _noImg = true;
  File? _path;

  final spaceH = SizedBox(height: 15);

  void _validate() {}

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
                    if (_path != null) {
                      _noImg = false;
                    }
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
        RegisterPage1.image = tempPath;
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
        RegisterPage1.image = tempPath;
      });
    } on PlatformException catch (e) {
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
            child: Text('Elige una foto!', style: TextStyle(fontSize: 20)),
          ),
          GestureDetector(
              onTap: (() {
                showBottomSheet();
              }),
              child: _noImg
                  ? const CircleAvatar(
                      backgroundImage: AssetImage('assets/no_image.jpg'),
                      backgroundColor: Colors.transparent,
                      radius: 55,
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(_path!),
                      backgroundColor: Colors.transparent,
                      radius: 55,
                    )),
          widget.txtName!,
          widget.txtEmail!,
          widget.txtPass!,
        ],
      ),
    );
  }
}

class RegisterPage2 extends StatefulWidget {
  RegisterPage2(
      {super.key,
      this.txtDescripcion,
      this.onChangeCareer,
      this.birthdatePicker,
      this.genderSelector});

  Widget? txtDescripcion;
  Widget? birthdatePicker;
  Widget? genderSelector;

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

  List<int> semesters = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  String? first;
  int? firstSemester;

  @override
  void initState() {
    super.initState();
    first = careers.first;
    firstSemester = semesters.first;
    RegisterPage2.selectedCareer = first;
    RegisterPage2.selectedSemester = firstSemester;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Genero',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: widget.genderSelector!,
          ),
          const Text(
            'Fecha de nacimiento',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: widget.birthdatePicker!,
          ),
          const Text(
            'Elige tu carrera:',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Center(child: StatefulBuilder(builder: (context, setState) {
              return DropdownButton(
                value: first,
                items: careers.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    RegisterPage2.selectedCareer = value;
                    first = value!;
                  });
                },
              );
            })),
          ),
          const Text(
            'Elige tu semestre:',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Center(
              child: StatefulBuilder(builder: (context, setState) {
                return DropdownButton(
                  value: firstSemester,
                  items: semesters.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem(
                        value: value, child: Text(value.toString()));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      RegisterPage2.selectedSemester = value;
                      firstSemester = value!;
                    });
                  },
                );
              }),
            ),
          ),
          const Text(
            '¡Cuentale a la gente sobre tí!',
            style: TextStyle(fontSize: 20),
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
        LottieBuilder.asset(
          'assets/animation/interests.json',
          width: 250,
          height: 250,
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: widget.multiSelectorChip!)
      ],
    ));
  }
}

class RegisterFilters extends StatefulWidget {
  RegisterFilters({super.key, this.listCareer, this.listGender});

  Widget? listCareer;
  Widget? listGender;
  static var rangeAges = List.empty(growable: true);
  static bool allAges = false;
  static var rating = const RangeValues(0.18, 0.23);

  @override
  State<RegisterFilters> createState() => _RegisterFiltersState();
}

class _RegisterFiltersState extends State<RegisterFilters> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getListGender(),
        getListCareer(),
        getAgeRange()
      ],
    );
  }

  Widget getListGender() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 15, 15, 15).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "Muéstrame",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        widget.listGender!
      ]),
    );
  }

  Widget getListCareer() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 15, 15, 15).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "Muéstrame por carrera",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        widget.listCareer!
      ]),
    );
  }

  Widget getAgeRange() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 15, 15, 15).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Rango de edades",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text("${getAge(RegisterFilters.rating.start)} - ${getAge(RegisterFilters.rating.end)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20))
            ],
          ),
          RangeSlider(
              max: 0.5,
              min: 0.18,
              divisions: 50,
              values: RegisterFilters.rating,
              onChanged: (newRating) {
                setState(() {
                  if (newRating.end == 0.5) {
                    RegisterFilters.allAges = true;
                  } else {
                    RegisterFilters.allAges = false;
                  }
                  RegisterFilters.rating = newRating;
                });
              }),
          Row(
            children: [
              const Expanded(
                  flex: 2,
                  child: Text(
                    "Mostrarme de todas las edades",
                    style: TextStyle(fontSize: 16),
                  )),
              Expanded(
                  child: Switch(
                // This bool value toggles the switch.
                value: RegisterFilters.allAges,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (bool newValue) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    if (newValue) {
                      RegisterFilters.rating = const RangeValues(0.18, 0.50);
                    }
                    RegisterFilters.allAges = newValue;
                  });
                },
              ))
            ],
          )
        ]),
      );
    });
  }

  String getAge(double age) {
    return (age * 100).round().toString();
  }
}

class RegisterSuccess extends StatelessWidget {
  const RegisterSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LottieBuilder.asset('assets/animation/successful.json', repeat: true),
        const Text(
          'Tu cuenta ha sido creada exitosamente, sigue los pasos de validación en tu correo.',
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
