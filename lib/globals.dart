import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';
import 'package:peppermintrc/helpers.dart';
import 'package:flutter/services.dart';

import 'bluetooth.dart';

enum OperationDir { forward, reverse }

enum DriveStatus { on, off }

class GlobalSingleton {
  static GlobalSingleton? _instance;
  String driveOn = "MOONS+ON;";
  String motorOn = "MOONS+ME;";
  String driveOff = "MOONS+OFF;";
  String motorOff = "MOONS+MD;";
  String revCmd = "MOONS+R;";
  String fwdCmd = "MOONS+F;";
  OperationDir _operationDir = OperationDir.forward;
  DriveStatus _drivestatus = DriveStatus.off;
  BluetoothState? _bluetoothState = BluetoothState.UNKNOWN;

  GlobalSingleton._internal() {
    _instance = this;
  }

  factory GlobalSingleton() => _instance ?? GlobalSingleton._internal();

  //Setters

  void setDriveStatus(DriveStatus updatedDrivestatus) {
    _drivestatus = updatedDrivestatus;
  }

  void setOperationDir(OperationDir updatedOperationDir) {
    _operationDir = updatedOperationDir;
  }

  //Getters

  OperationDir getOperationDir() {
    return _operationDir;
  }

  DriveStatus getDriveStatus() {
    return _drivestatus;
  }

/*The following functions are used to send commands to the bluetooth device.
It take svarious parameters and sends the command to the device.
The command is sent as a string.
The string is converted to a byte array and then sent to the device.

*/
  Future command(String command) async {
    List<int> x = List<int>.from(ascii.encode(command));
// This part works on a robot [Thumbs up]
    String result = const AsciiDecoder().convert(x);
    if (isConnected) {
      connection!.output.add(ascii.encoder.convert(result));
      await connection!.output.allSent;
    }
  }

  Future<void> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await RemoteControl.getPairedDeviceList()
          .timeout(const Duration(seconds: 8));
    } else {
      await RemoteControl.getPairedDeviceList();
    }
  }
}
