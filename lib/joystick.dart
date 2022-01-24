// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter_joystick/flutter_joystick.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:flutter/services.dart';
// import 'package:test/main.dart';

// class joystickFile1 extends StatefulWidget {
//   const joystickFile1(context, {Key? key}) : super(key: key);

//   @override
//   joystickFile1State createState() => joystickFile1State();
// }

// class joystickFile1State extends State<joystickFile1> {
//   @override
//   Widget build(BuildContext context) {
//     bool _value1 = true;
//     BluetoothConnection? connection;
//     int deviceState = 0;

//     return 
//   }
// }

// Future command(String data) async {
//   List<int> x = List<int>.from(ascii.encode(data));

//   String result = const AsciiDecoder().convert(x);
//   print(result);
//   BluetoothConnection? connection;
//   if (connection != null) {
//     connection.output.add(ascii.encoder.convert(result));

//     await connection.output.allSent;
//   }
// }

// _repeatCmd(int millisec, String cmd) {
//   Timer.periodic(Duration(milliseconds: millisec), (Timer t) => command(cmd));
// }
// // 