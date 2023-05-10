import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class AlertWidget {
  BuildContext? context;
  ProgressDialog? pd;
  AlertWidget({this.context}) {
    pd = ProgressDialog(context: context);
  }

  static Future<void> showMessage(
      BuildContext context, String title, String message) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.all(10)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'))
              ],
            ));
  }

  void showProgress() {
    pd!.show(
        msg: "¡Espere por favor!",
        msgColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 21, 21, 21),
        progressBgColor: Theme.of(context!).colorScheme.primary,
        progressValueColor: Theme.of(context!).colorScheme.onPrimary,
        barrierColor: Colors.white.withOpacity(0.2));
  }
  
  void closeProgress() {
    pd!.close();
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
