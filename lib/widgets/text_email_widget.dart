import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextEmailWidget extends StatefulWidget {
  String label;
  String hint;
  String msgError;
  var controlador;
  var error = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEmailWidget(this.label, this.hint, this.msgError) {}
  @override
  State<StatefulWidget> createState() => _TextEmailWidgetState();
//State<getDropdownButton> createState() => _getDropdownButtonState(sele);
}

class _TextEmailWidgetState extends State<TextEmailWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: TextFormField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                      child: const Icon(Icons.email, size: 14)),
                  labelStyle: const TextStyle(fontSize: 14),
                  errorStyle: const TextStyle(fontSize: 14),
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                onSaved: (value) {
                  widget.controlador = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    widget.error = true;
                    return "Enter your email";
                  } else if (!EmailValidator.validate(value)) {
                    widget.error = true;
                    return "Enter a valid email";
                  } else if (widget.error) {
                    widget.error = true;
                    return widget.msgError;
                  }
                },
                onChanged: (value) => setState(() {
                      widget.controlador = value;
                      widget.error = false;
                    }))));
  }
}
