// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:flutter_joystick/flutter_joystick.dart';
// import './robot_list.dart' as rl;

// const step = 40;

// // class JoystickExampleApp extends StatelessWidget {
// //   const JoystickExampleApp({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       home: Scaffold(
// //         body: MainPage(),
// //       ),
// //     );
// //   }
// // }

// // class MainPage extends StatelessWidget {
// //   const MainPage({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: <Widget>[
// //         SizedBox(
// //           height: 300,
// //           width: 250,
// //           child: JoystickExample(
// //             onClick: null,
// //           ),
// //         )
// //       ],
// //     );
// //   }
// // }

// class JoystickExample extends StatefulWidget {
//   Function? onClick;
//   JoystickExample({Key? key, this.onClick}) : super(key: key);

//   @override
//   _JoystickExampleState createState() => _JoystickExampleState();
// }

// class _JoystickExampleState extends State<JoystickExample> {
//   double x = 100;
//   double y = 100;
//   BluetoothConnection? connection;
//   bool get isConnected => (connection?.isConnected ?? false);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Container(
//               color: Colors.transparent,
//             ),
//             Align(
//               alignment: const Alignment(0, 0.8),
//               child: Joystick(
//                 listener: (details) {
//                   setState(() {});
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void _onDataReceived(Uint8List data) {
//   int backspacesCounter = 0;
//   data.forEach((byte) {
//     if (byte == 8 || byte == 127) {
//       backspacesCounter++;
//     }
//   });
//   Uint8List buffer = Uint8List(data.length - backspacesCounter);
//   int bufferIndex = buffer.length;

//   // Apply backspace control character
//   backspacesCounter = 0;
//   for (int i = data.length - 1; i >= 0; i--) {
//     if (data[i] == 8 || data[i] == 127) {
//       backspacesCounter++;
//     } else {
//       if (backspacesCounter > 0) {
//         backspacesCounter--;
//       } else {
//         buffer[--bufferIndex] = data[i];
//       }
//     }
//   }
// }
