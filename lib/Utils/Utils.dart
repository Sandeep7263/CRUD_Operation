import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class Utils {
  // Toast message
  static void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Flushbar error message (now returns Future)
  static Future<void> flushbarErrorMessage(
    String message,
    BuildContext context,
  ) async {
    await Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.red,
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(Icons.sim_card_alert_outlined, color: Colors.white),
    ).show(context);
  }

  // Success Flushbar
 static Future<void> flushbarSuccessMessage(
      String message, BuildContext context) async {
    await Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.green,
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: const Icon(Icons.done, color: Colors.white),
    ).show(context);
  }
}



