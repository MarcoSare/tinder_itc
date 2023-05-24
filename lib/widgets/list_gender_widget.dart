import 'package:flutter/material.dart';

class ListGenderWidget extends StatefulWidget {
  ListGenderWidget({super.key, required this.control});
  String control;

  @override
  State<ListGenderWidget> createState() => _ListGenderWidgetState();
}

class _ListGenderWidgetState extends State<ListGenderWidget> {
  @override
  initState() {
    dropDownValue = widget.control;
    if (dropDownValue == "male") {
      dropDownValue = "Hombres";
    } else if (dropDownValue == "female") {
      dropDownValue = "Mujeres";
    } else {
      dropDownValue = "Todos";
    }
  }

  List<String> genders = ["Hombre", "Mujeres", "Todos"];
  late String dropDownValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
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
            hintText: "Genero",
            labelText: "Genero"),
        items: genders.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
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
