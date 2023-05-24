import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/widgets/list_carrer_widget.dart';
import 'package:tinder_itc/widgets/list_gender_widget.dart';

class FilterSettingScreen extends StatefulWidget {
  const FilterSettingScreen({super.key});

  @override
  State<FilterSettingScreen> createState() => _FilterSettingScreenState();
}

class _FilterSettingScreenState extends State<FilterSettingScreen> {
  late String controlList = "female";
  late String carrer = "Todas";
  var rating = RangeValues(0.18, 0.23);
  final mFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ajustes de búsqueda"),
        ),
        body: StreamBuilder(
            stream: mFirestore
                .collection('usuarios')
                .doc(userProvider.user!.id)
                .collection('filters')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text(
                  'No Data...',
                );
              } else {
                controlList = snapshot.data!.docs[0]['gender'].toString();
                rating = RangeValues(snapshot.data!.docs[0]['ages'][0] / 100,
                    snapshot.data!.docs[0]['ages'][1] / 100);
                carrer = controlList = snapshot.data!.docs[0]['carrer'];
                carrer = carrer == "all" ? "Todas" : carrer;
                return ListView(
                  children: [
                    getCardPeopleShow(),
                    getCardAges(context),
                    getCardCarrer(),
                    getButtom()
                  ],
                );
              }
            }));
  }

  Widget getCardAges(BuildContext context) {
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
            offset: Offset(0, 1), // changes position of shadow
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
            Text("${getAge(rating.start)} - ${getAge(rating.end)}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
          ],
        ),
        RangeSlider(
            max: 0.5,
            min: 0.18,
            divisions: 50,
            values: rating,
            onChanged: (newRating) {
              setState(() {
                rating = newRating;
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
              value: true,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {});
              },
            ))
          ],
        )
      ]),
    );
  }

  Widget getButtom() {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color(0xff1f005c),
              Color(0xff5b0060),
              Color(0xff870160),
              Color(0xffac255e),
              Color(0xffca485c),
              Color(0xffe16b5c),
              Color(0xfff39060),
              Color(0xffffb56b),
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
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
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0, backgroundColor: Colors.transparent),
          child: const Center(
            child: Text(
              "Guardar cambios",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          onPressed: () {},
        ));
  }

  Widget getCardPeopleShow() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 15, 15, 15).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "Muéstrame",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        ListGenderWidget(control: controlList)
      ]),
    );
  }

  Widget getCardCarrer() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 15, 15, 15).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "Muéstrame por carrera",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        ListCarrerWidget(control: carrer)
      ]),
    );
  }

  String getAge(double age) {
    return (age * 100).round().toString();
  }
}
