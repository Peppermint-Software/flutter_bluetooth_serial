import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:peppermintrc/bluetooth.dart';

bool get isConnected => connection != null && connection!.isConnected;

class ReaderOfUint {
  Future something(Uint8List array, int charCode, int n, int index) async {
    int hash = 42;

    if (array[index] == charCode && array[index - 1] == hash) {
      String we;
      for (int i = 1; i <= n; i++) {
        List<int> something = List<int>.from([array[index + i]]);
        String qwer = const AsciiDecoder().convert(something);
        we = qwer;
        return we;
      }

      return;
    }
  }
}

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
