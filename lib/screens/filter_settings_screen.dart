import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:tinder_itc/firebase/users_firebase.dart';
import 'package:tinder_itc/models/filter_model.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/network/api_users.dart';
import 'package:tinder_itc/provider/filters_provider.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/screens/dashboard_screen.dart';
import 'package:tinder_itc/screens/home_screen.dart';
import 'package:tinder_itc/screens/match_screen.dart';
import 'package:tinder_itc/widgets/alert_widget.dart';
import 'package:tinder_itc/widgets/list_carrer_widget.dart';
import 'package:tinder_itc/widgets/list_gender_widget.dart';

class FilterSettingScreen extends StatefulWidget {
  const FilterSettingScreen({super.key});

  @override
  State<FilterSettingScreen> createState() => _FilterSettingScreenState();
}

class _FilterSettingScreenState extends State<FilterSettingScreen> {
  var rating = const RangeValues(0.18, 0.23);
  late bool allAges = false;
  FilterModel? filterModel;
  late UserModel userModel;
  late ListCarrerWidget listCarrerWidget;
  late ListGenderWidget listGenderWidget;
  late AlertWidget alertWidget;
  late FiltersProvider filterProvider;

  @override
  Widget build(BuildContext context) {
    alertWidget = AlertWidget(context: context);
    final userProvider = Provider.of<UserProvider>(context);
    filterProvider = Provider.of<FiltersProvider>(context);
    userModel = userProvider.user!;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ajustes de búsqueda"),
        ),
        body: FutureBuilder(
            future: getFilter(userProvider.user!.id!),
            builder: (context, AsyncSnapshot<FilterModel> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    getCardPeopleShow(),
                    getCardAges(context),
                    getCardCarrer(),
                    getButtom(context)
                  ],
                );
              } else {
                return const Center(
                  child: Text("Loading..."),
                );
              }
            }));
  }

  Future<FilterModel> getFilter(String id) async {
    filterModel = await UsersFireBase.getFilters(id: id);
    listCarrerWidget = ListCarrerWidget(
      control: filterModel!.carrer!,
    );
    listGenderWidget = ListGenderWidget(control: filterModel!.gender!);
    if (filterModel!.ages == 'Todos') {
      allAges = true;
      rating = const RangeValues(0.18, 0.50);
    } else {
      List<dynamic> ages = filterModel!.ages;
      rating = RangeValues(ages[0] / 100, ages[1] / 100);
    }
    return filterModel!;
  }

  Future<bool> setFilters() async {
    String gender = listGenderWidget.control;
    String auxCarrer = listCarrerWidget.control;
    List<int> rangeAges = List.empty(growable: true);

    if (gender != 'Todos') {
      if (gender == "Mujeres") {
        gender = "female";
      } else {
        gender = "male";
      }
    }

    if (!allAges) {
      rangeAges.add(int.parse(getAge(rating.start)));
      rangeAges.add(int.parse(getAge(rating.end)));
    }
    print(userModel.id!);
    FilterModel newFilter = FilterModel(
        id: filterModel!.id,
        gender: gender,
        carrer: auxCarrer,
        ages: allAges ? 'Todos' : rangeAges);
    bool res = await UsersFireBase.setFilters(
        filter: newFilter, idUser: userModel.id!);
    print(res);
    return res;
  }

  Widget getCardAges(BuildContext context) {
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
              Text("${getAge(rating.start)} - ${getAge(rating.end)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20))
            ],
          ),
          RangeSlider(
              max: 0.5,
              min: 0.18,
              divisions: 50,
              values: rating,
              onChanged: (newRating) {
                setState(() {
                  if (newRating.end == 0.5) {
                    allAges = true;
                  } else {
                    allAges = false;
                  }
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
                value: allAges,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (bool newValue) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    if (newValue) {
                      rating = const RangeValues(0.18, 0.50);
                    }
                    allAges = newValue;
                  });
                },
              ))
            ],
          )
        ]),
      );
    });
  }

  Widget getButtom(BuildContext context) {
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
          onPressed: () async {
            alertWidget.showProgress();
            await setFilters();
            List<UserModel> listUsers =
                await ApiUsers.getAllUsers(userModel.id!);
            filterProvider.setFilter(listUsers);
            alertWidget.closeProgress();
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashBoardScreen()),
              (Route<dynamic> route) => false,
            );
          },
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
        listGenderWidget
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
        listCarrerWidget
      ]),
    );
  }

  String getAge(double age) {
    return (age * 100).round().toString();
  }
}
