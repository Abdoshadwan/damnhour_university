import 'dart:developer';
import 'package:flutter/widgets.dart';

class ScreenSize {
  static late double width;
  static late double height;

  static void initscreensize(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    log(height.toString());
    log(width.toString());
  }
}

String? token = '';

int? userId;
