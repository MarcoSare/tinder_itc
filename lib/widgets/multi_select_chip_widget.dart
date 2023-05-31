import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class MultiSelectChipWidget extends StatefulWidget {
  MultiSelectChipWidget({super.key, required this.items});

  var initialValues;
  List<String?> items;
  List<String?> interestsList = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  State<MultiSelectChipWidget> createState() => _MultiSelectChipWidgetState();
}

class _MultiSelectChipWidgetState extends State<MultiSelectChipWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      widget.interestsList.addAll(widget.initialValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: MultiSelectChipField(
          headerColor: Colors.transparent,
          chipColor: const Color(0xFFFFB3B5),
          textStyle: const TextStyle(color: Colors.black),
          selectedTextStyle: const TextStyle(color: Colors.white),
          selectedChipColor: const Color(0xFF920025),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.transparent)),
          items: widget.items
              .map<MultiSelectItem<String?>>(
                  (value) => MultiSelectItem(value, value!))
              .toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Selecciona al menos 1 tema de interés, por favor.';
            }
          },
          scroll: false,
          onTap: (values) {
            setState(() {
              widget.interestsList = values;
              print(widget.interestsList);
            });
          },
          title: const Text('Selecciona tus intereses'),
          initialValue: widget.interestsList),
    );
  }
}
