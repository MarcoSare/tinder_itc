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
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Form(
            key: widget.formKey,
            child: TextFormField(
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                obscureText: widget.visible,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorDark)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide()),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorDark)),
                  labelText: "Password",
                  hintText: ("Enter your password"),
                  hintStyle: TextStyle(fontSize: 14),
                  prefixIcon: Container(
                    margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: Icon(Icons.vpn_key_sharp, size: 14),
                  ),
                  suffixIcon: IconButton(
                    icon: widget.visible
                        ? Icon(
                            Icons.visibility_off,
                          )
                        : Icon(Icons.visibility),
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
