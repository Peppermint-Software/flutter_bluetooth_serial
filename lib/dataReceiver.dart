import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// This File is a trial run in case of the failure of the old method of receiving the data from the robo

class DataReceiver {
  static DataReceiver? _instance;
  DataReceiver._internal2() {
    _instance = this;
  }
  BluetoothConnection? connection;

  void receiver() {
    Stream<Uint8List>? funnel = connection!.input;
    funnel?.listen(dataReceived).onDone(() {});
  }

  Future<String> dataReceived(Uint8List data) {
    int backspacesCounter = 0;
    String batStatus;

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
            print("Data value ==>" + data.toString());

            List<int> batstatus = List<int>.from([
              data[i + 1],
              data[i + 2],
              data[i + 3],
              data[i + 4],
            ]);
        String res;
            }
          }
        }
      }
    }
    return Future.value(proxy.toString());
  }
}


 List<int> x = List<int>.from(ascii.encode(command));
// This part works on a robot [Thumbs up]
    String result = const AsciiDecoder().convert(x);
    if (isConnected) {
      connection!.output.add(ascii.encoder.convert(result));
      await connection!.output.allSent;}