import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// This File is a trial run in case of the failure of the old method of receiving the data from the robot

class DataReceiver {
  static DataReceiver? _instance;
  DataReceiver._internal2() {
    _instance = this;
  }
  BluetoothConnection? connection;
  Future<dynamic> dataReceived(Uint8List data) async {
    int backspacesCounter = 0;
    final Stream<Uint8List>? funnel = connection!.input;

    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }

    Uint8List proxy = Uint8List(data.length - backspacesCounter);
    int proxyIndex = proxy.length;

    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
        } else {
          proxy[--proxyIndex] = data[i];
          if (data[i] == 86 && data[i - 1] == 42) {
            List<int> batstatus = List<int>.from([
              data[i + 1],
              data[i + 2],
              data[i + 3],
              data[i + 4],
            ]);
          }
        }
      }
    }
    return;
  }
}
