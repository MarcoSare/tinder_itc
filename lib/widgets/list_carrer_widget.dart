import 'package:flutter/material.dart';

class ListCarrerWidget extends StatefulWidget {
  ListCarrerWidget({super.key, required this.control});
  String control;

  @override
  State<ListCarrerWidget> createState() => _ListCarrerWidgetState();
}

class _ListCarrerWidgetState extends State<ListCarrerWidget> {
  @override
  initState() {
    dropDownValue = widget.control;
  }

  List<String> carrers = [
    'Ing. Sistemas Computacionales',
    'Ing. Mecatrónica',
    'Lic. Administración de Empresas',
    'Ing. Gestión Emprearial',
    'Ing. Bioquímica',
    'Ing. Qímica ',
    'Ing. Ambiental',
    'Ing. Industrial',
    'Ing. Mecánica',
    'Todas'
  ];
  late String dropDownValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: dropDownValue,
        dropdownColor: Theme.of(context).colorScheme.background,
        icon: const Icon(Icons.expand_more),
        decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 14, right: 14),
              child: const Icon(
                Icons.man,
              ),
            ),
            hintText: "Carrera",
            labelText: "Carrera"),
        items: carrers.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          dropDownValue = newValue!;
          widget.control = newValue;
        },
      ),
    );
  }
}
