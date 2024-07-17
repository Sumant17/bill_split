import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomFlashMessage {
  static void showSuccessToast(BuildContext context, String message) {
    _showCustomToast(context, message, Colors.green, Icons.check_circle);
  }

  static void showErrorToast(BuildContext context, String message) {
    _showCustomToast(context, message, Colors.red, Icons.error);
  }

  static void _showCustomToast(
      BuildContext context, String message, Color bgColor, IconData icon) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5), color: bgColor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }
}
