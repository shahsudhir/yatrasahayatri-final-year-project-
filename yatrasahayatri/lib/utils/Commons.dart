import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const orange = Color(0xfff96d34);
  static var orangeLight = orange.withOpacity(0.12);
  static const orangeLight12 = Color(0x02f96d34);
  static const blue = Color(0xff4f1ed2);
  static const white = Color(0xffffffff);
  static const grey = Colors.grey;
  static const green = Colors.green;
}

class Commons{
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static void timeValidation(){

  }
}
