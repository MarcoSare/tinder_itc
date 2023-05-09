import 'package:flutter/material.dart';

class AlertWidget {

  static Future<void> showMessage(BuildContext context, String title, String message) async {
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.all(10)
            ),
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: const Text('Ok'))
        ],
      )
    );
  }

  static Future<void> showMessageWithActions(BuildContext context,String title, String message, List<Widget>? actions) async {
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: actions
      )
    );
  }
  
}