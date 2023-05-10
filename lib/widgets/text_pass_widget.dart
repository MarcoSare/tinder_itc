import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextPassWidget extends StatefulWidget {
  var visible = true;
  var error = false;
  var controlador;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() => _TextPassWidgetState();
//State<getDropdownButton> createState() => _getDropdownButtonState(sele);
}

class _TextPassWidgetState extends State<TextPassWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Form(
            key: widget.formKey,
            child: TextFormField(
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                obscureText: widget.visible,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  hintText: ("Ingresa tu contraseña"),
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: Container(
                    margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: const Icon(Icons.vpn_key_sharp, size: 14),
                  ),
                  suffixIcon: IconButton(
                    icon: widget.visible
                        ? const Icon(
                            Icons.visibility_off,
                          )
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() => widget.visible = !widget.visible);
                    },
                  ),
                  labelStyle: TextStyle(fontSize: 14),
                  errorStyle: TextStyle(fontSize: 14),
                ),
                onSaved: (value) {
                  widget.controlador = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    widget.error = true;
                    return "Enter your password";
                  } else if (widget.error) {
                    widget.error = true;
                    return "Email or password wrong";
                  }
                },
                onChanged: (value) => setState(() {
                      widget.controlador = value;
                      widget.error = false;
                    }))));
  }
}
