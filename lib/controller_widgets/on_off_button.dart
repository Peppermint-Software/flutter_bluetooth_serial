// import 'dart:async';
// import 'dart:convert';
// import 'dart:isolate';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:sliding_switch/sliding_switch.dart';
// import './robot_list.dart';

// void main() => runApp(const OnOffButton());

// class OnOffButton extends StatefulWidget {
//   const OnOffButton({Key? key}) : super(key: key);

//   @override
//   _OnOffButtonState createState() => _OnOffButtonState();
// }

// class _OnOffButtonState extends State<OnOffButton> {
//   BluetoothConnection? connection;
//   bool isConnecting = true;


//   @override
//   Widget build(BuildContext context) {
//     bool _value = false;

//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.all(5),
//       child: SlidingSwitch(
//         value: _value,
//         width: 150,
//         onChanged: (value) => setState(() {
//           _value = value;

//           const oneSec = Duration(seconds: 3);
//           Timer.periodic(
//               oneSec, (Timer t) => _command("MOONS+ON;", "MOONS+ME;"));
//         }),
//         height: 40,
//         animationDuration: const Duration(milliseconds: 40),
//         onTap: () {
//           // _sendMessage;
//         },
//         onDoubleTap: () {},
//         onSwipe: () {
//           // _sendMessage("Moons+ON");
//         },
//         textOff: "OFF",
//         textOn: "ON",
//         colorOn: const Color(0xff64dd17),
//         colorOff: const Color(0xffdd2c00),
//         background: const Color(0xffe4e5eb),
//         buttonColor: const Color(0xfff7f5f7),
//         inactiveColor: const Color(0xff636f7b),
//       ),
//     );
//   }
// }

// // Future<void> _initIsolate1() async {
// //   var receivePort = ReceivePort();
// //   await Isolate.spawn(echo, receivePort.sendPort);

// //   // The 'echo' isolate sends it's SendPort as the first message
// //   var sendPort = await receivePort.first;

// //   var msg = await sendReceive(sendPort, "MOONS+ON;");
// //   print('$msg');
// // }

// // // the entry point for the isolate
// // echo(SendPort sendPort) async {
// //   // Open the ReceivePort for incoming messages.
// //   var port = ReceivePort();

// //   // Notify any other isolates what port this isolate listens to.
// //   sendPort.send(port.sendPort);

// //   await for (var msg in port) {
// //     var data = msg[0];
// //     SendPort replyTo = msg[1];
// //     replyTo.send(data);
// //   }
// // }

// // Future sendReceive(SendPort port, msg) {
// //   ReceivePort response = ReceivePort();
// //   port.send([msg, response.sendPort]);
// //   return response.first;
// // }
