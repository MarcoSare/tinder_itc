import 'package:flutter/material.dart';

class GenderSelectorWidget extends StatefulWidget {
  GenderSelectorWidget({super.key,});

  var gender=false;

  @override
  State<GenderSelectorWidget> createState() => _GenderSelectorWidgetState();
}

class _GenderSelectorWidgetState extends State<GenderSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 75,
        child: FittedBox(
          fit: BoxFit.cover,
          child: Switch(
            value: widget.gender, 
            onChanged: (value){
              setState(() {
                widget.gender=value;
              });
            },
            activeColor: Colors.pink,
            activeThumbImage: const AssetImage('assets/female.png'),
            inactiveThumbColor: Color.fromARGB(255, 16, 109, 185),
            inactiveThumbImage: const AssetImage('assets/male.png'),
            inactiveTrackColor: Colors.blue ,
          ),
        ),
      ),
    );
  }
}