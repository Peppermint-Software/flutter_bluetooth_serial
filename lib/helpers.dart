import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:peppermintrc/bluetooth.dart';

bool get isConnected => connection != null && connection!.isConnected;

class IconDashboard {
  Color? yesColor;
  Color? noColor;
  int? iconhash;
  IconDashboard(noColor, yesColor, condition, iconhash) {
    Icon(
      IconData(iconhash, fontFamily: 'MaterialIcons'),
      color: condition ? yesColor : noColor,
    );
  }
}
