import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:tinder_itc/models/user_model.dart';

class DetailsUser extends StatefulWidget {
  UserModel user;
  DetailsUser({super.key, required this.user});

  @override
  State<DetailsUser> createState() => _DetailsUserState();
}

class _DetailsUserState extends State<DetailsUser> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          extendBody: true,
          body: ListView(
            children: [
              SizedBox(
                height: 500,
                width: width,
                child: Stack(
                  children: [
                    Image.network(
                      widget.user.profilePicture!,
                      height: 450,
                      width: width,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                        bottom: 0,
                        right: 50,
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
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
                              )),
                          height: 100,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                shape: const CircleBorder()),
                            child: const Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.user.name!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "23",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "En linea",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 0.5, color: Colors.grey)),
                        )),
                    const Text(
                      "Sobre mí",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      widget.user.aboutMe!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 0.5, color: Colors.grey)),
                        )),
                    const Text(
                      "Carrera",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        widget.user.carrer!,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        "Semestre",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      title: Text(widget.user.semester!.toString()),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 0.5, color: Colors.grey)),
                        )),
                    AbsorbPointer(
                      child: MultiSelectChipField(
                        scroll: false,
                        chipColor: Colors.transparent,
                        headerColor: Colors.transparent,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent)),
                        textStyle: TextStyle(
                            color: Theme.of(context).primaryColorDark),
                        title: const Text("Intereses"),
                        items: widget.user.interests!
                            .map<MultiSelectItem<String?>>(
                                (value) => MultiSelectItem(value, value!))
                            .toList(),
                        icon: const Icon(Icons.check),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: Theme.of(context).brightness == Brightness.light
                      ? [
                          Colors.transparent,
                          const Color.fromARGB(171, 152, 152, 152),
                          const Color.fromARGB(208, 119, 119, 119),
                        ]
                      : [
                          Colors.transparent,
                          const Color.fromARGB(171, 14, 14, 14),
                          const Color.fromARGB(208, 9, 9, 9),
                        ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder()),
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder()),
                      child: const Icon(
                        Icons.star,
                        color: Colors.blue,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder()),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.pinkAccent,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }
}
