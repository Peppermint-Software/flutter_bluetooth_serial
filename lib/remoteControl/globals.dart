import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:peppermintrc/remoteControl/helpers.dart';

import 'remoteControl.dart';

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
  String joystickStopCmd = "MOONS+JSR0A180;";
  late Timer onTimerVar;
  late Timer offTimerVar;
  var ppmtGreenColor = Color.fromARGB(255, 76, 175, 80);
  var ppmtBackgroundColor = Colors.white;

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
It takes various parameters and sends the command to the device.
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

  Future rmagnitude(Uint8List array, int charCode, int n, int index) async {
    int hash = 42;
// TODO:have to find a better way to encapsulate the logic of this code
    if (array[index] == charCode && array[index - 1] == hash) {
      String we;
      for (int i = 1; i <= n; i++) {
        List<int> something = List<int>.from([array[index + i]]);
        String qwer = const AsciiDecoder().convert(something);
        we = qwer;
        return we;
      }
    }
  }

/*
Creates the offest that is required t send to the micro controller that exists 
in the robot. It interprets the joystick data that based on the commands guidelines 
as provided by the Electronics team
*/
  String offsetJoystickLogic(
      double detailsx, double detailsy, double x, double y, var degree) {
    double r = sqrt(pow(x, 2).toInt() + pow(y, 2).toInt()).abs();
    String s = r.toStringAsFixed(0);

    int radians = (180 * (degree / pi)).toInt();
    radians >= 1 && radians <= 180
        ? radians = radians + 90
        : (radians <= 0 && radians >= -90)
            ? radians = 90 + radians
            : (radians < -90 && radians >= -180)
                ? radians = 450 + radians
                : radians;
    return '${s}A$radians;';
  }
}
