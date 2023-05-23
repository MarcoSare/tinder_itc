import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  DatePickerWidget({super.key, this.msgError});

  String? msgError;
  var date;
  var error = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {

  TextEditingController txtDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        controller:txtDate,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: const Icon(Icons.calendar_month, size: 14)),
          hintText: 'Elige una fecha'
        ),
        readOnly: true,
        onTap:() async {
          final selectedDate = await showPicker();
          setState(() {
            widget.date=selectedDate;
            txtDate.text=selectedDate != null ? DateFormat.yMd().format(selectedDate) : '';
          });
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
       validator: (value){
        if(value!.isEmpty){
          return 'Elige tu fecha de nacimiento...';
        }else if(widget.error){
          return widget.msgError;
        }
       },
       onChanged: (value)=> setState(() {
          widget.date = value;
          widget.error = false;
       }),
      ),
    );
  }

  Future<DateTime?> showPicker() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800), 
      lastDate: DateTime(2024),
    );
  }
}