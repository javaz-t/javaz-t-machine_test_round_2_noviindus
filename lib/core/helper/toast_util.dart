
import 'package:flutter/material.dart';

class ToastUtils {
  // Generic toast
  static void show(BuildContext context, String message,
      {Color backgroundColor = Colors.black}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Success message
  static void showSuccess(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.green);
  }

  // Error message
  static void showError(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.red);
  }

  // Info message
  static void showInfo(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.blueGrey);
  }
}
