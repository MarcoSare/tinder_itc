import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormWidget extends StatefulWidget {
  String label;
  String hint;
  String msgError;
  int inputType;
  int lenght;
  int? maxLines;
  IconData icono;
  var controlador;
  var error = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextFormWidget(this.label, this.hint, this.msgError, this.icono,
      this.inputType, this.lenght,
      {super.key});

  TextFormWidget.area(this.label, this.hint, this.msgError, this.icono,
      this.inputType, this.lenght, this.maxLines,
      {super.key});
  @override
  State<StatefulWidget> createState() => _TextFormWidgetState();
//State<getDropdownButton> createState() => _getDropdownButtonState(sele);
}

class _TextFormWidgetState extends State<TextFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: TextFormField(
                maxLines: widget.maxLines ?? 1,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(widget.lenght),
                ],
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                      child: Icon(widget.icono, size: 14)),
                  labelStyle: const TextStyle(fontSize: 14),
                  errorStyle: const TextStyle(fontSize: 14),
                ),
                keyboardType: widget.inputType == 0
                    ? TextInputType.number
                    : TextInputType.text,
                onSaved: (value) {
                  widget.controlador = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Llena este campo por favor";
                  } else if (widget.error) {
                    return widget.msgError;
                  }
                },
                onChanged: (value) => setState(() {
                      widget.controlador = value;
                      widget.error = false;
                    }))));
  }
}
