






/* To be considered for v0.6 ?  */








// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// class BluetoothApp extends StatefulWidget {
//   const BluetoothApp({Key? key}) : super(key: key);

//   @override
//   _BluetoothAppState createState() => _BluetoothAppState();
// }

// class _BluetoothAppState extends State<BluetoothApp> {
//   BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
//   late BluetoothConnection connection;


//   bool isDisconnecting = true;

//   Map<String, Color> colors = {
//     'onBorderColor': Colors.green,
//     'offBorderColor': Colors.red,
//     'neutralBorderColor': Colors.transparent,
//     'onTextColor': Colors.green,
//     'offTextColor': Colors.amber,
//     'neutralTextColor': Colors.blue,
//   };

//   int value = 2;

//   bool get isConnected => connection.isConnected;

//   List<BluetoothDevice> _devicesList = [];
//   late BluetoothDevice _device;
//   bool _connected = false;
//   bool _isButtonUnavailable = false;

//   @override
//   void initState() {
//     super.initState();

//     FlutterBluetoothSerial.instance.state.then((state) {
//       setState(() {
//         _bluetoothState = state;
//       });
//     });


//     enableBluetooth();

//     FlutterBluetoothSerial.instance
//         .onStateChanged()
//         .listen((BluetoothState state) {
//       setState(() {
//         _bluetoothState = state;
//         if (_bluetoothState == BluetoothState.STATE_OFF) {
//           _isButtonUnavailable = true;
//         }
//         getPairedDevices();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     if (isConnected) {
//       isDisconnecting = true;
//       connection.dispose();
//     }

//     super.dispose();
//   }

//   Future<bool> enableBluetooth() async {
//     _bluetoothState = await FlutterBluetoothSerial.instance.state;

//     if (_bluetoothState == BluetoothState.STATE_OFF) {
//       await FlutterBluetoothSerial.instance.requestEnable();
//       await getPairedDevices();
//       return true;
//     } else {
//       await getPairedDevices();
//     }
//     return false;
//   }

//   Future<void> getPairedDevices() async {
//     List<BluetoothDevice> devices = [];

//     try {
//       devices = await _bluetooth.getBondedDevices();
//     } on PlatformException {
//       print("Error");
//     }

//     if (!mounted) {
//       return;
//     }

//     setState(() {
//       _devicesList = devices;
//     });
//   }

//   _addItem() {
//     setState(() {
//       int? value = 2;
//       value = value + 1;
//     });
//   }

//   _buildRow(int index) {
//     return Text("Item " + index.toString());
//   }

// // ##############################################################################################################################################################
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         key: _scaffoldKey,
//         appBar: PreferredSize(
//             preferredSize: const Size.fromHeight(1),
//             child: AppBar(
//               backgroundColor: Colors.transparent,
//               leading: const Icon(Icons.bluetooth_audio_rounded),
//             )),
//         body: SizedBox(
//           height: 300,
//           width: 300,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Flexible(
//                 child: Visibility(
//                   visible: _isButtonUnavailable &&
//                       _bluetoothState == BluetoothState.STATE_ON,
//                   child: const LinearProgressIndicator(
//                     backgroundColor: Colors.yellow,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//                   ),
//                 ),
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[],
//               ),
//               Flexible(
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(2.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: const <Widget>[
//                           // DropdownButton(
//                           //   items: _getDeviceItems(),
//                           //   onChanged: (value) => setState(() => _device),
//                           //   value: _devicesList.isNotEmpty ? _device : null,
//                           // ),

//                           // ListView.builder(
//                           //     scrollDirection: Axis.vertical,
//                           //     shrinkWrap: true,
//                           //     itemCount: value,
//                           //     itemBuilder: (context, index) =>
//                           //         _buildRow(index)),
//                           // FloatingActionButton(
//                           //   onPressed: _addItem,
//                           //   child: const Icon(Icons.add),
//                           // ),
//                         ],
//                       ),
//                     ),
//                     // Padding(
//                     //   padding: const EdgeInsets.all(5.0),
//                     //   child: Card(
//                     //     shape: RoundedRectangleBorder(
//                     //       side: const BorderSide(
//                     //         width: 3,
//                     //       ),
//                     //       borderRadius: BorderRadius.circular(4.0),
//                     //     ),
//                     //     elevation: _deviceState == 0 ? 4 : 0,
//                     //     child: Padding(
//                     //       padding: const EdgeInsets.all(8.0),
//                     //       child: Row(
//                     //         children: <Widget>[
//                     //           // Expanded(
//                     //           //   child: OutlinedButton(
//                     //           //     onPressed: _connected
//                     //           //         ? _sendOnMessageToBluetooth
//                     //           //         : null,
//                     //           //     child: const Text("ON"),
//                     //           //   ),
//                     //           // ),
//                     //           // Expanded(
//                     //           //   child: OutlinedButton(
//                     //           //     onPressed: _connected
//                     //           //         ? _sendOffMessageToBluetooth
//                     //           //         : null,
//                     //           //     child: const Text("OFF"),
//                     //           //   ),
//                     //           // ),
//                     //         ],
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// // ####################################################################################################################################################
//   // List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
//   //   List<DropdownMenuItem<BluetoothDevice>> items = [];
//   //   if (_devicesList.isEmpty) {
//   //     items.add(const DropdownMenuItem(
//   //       child: Text('NONE'),
//   //     ));
//   //   } else {
//   //     for (var device in _devicesList) {
//   //       items.add(DropdownMenuItem(
//   //         child: Text(device.name.toString()),
//   //         value: device,
//   //       ));
//   //     }
//   //   }
//   //   return items;
//   // }

//   void _connect() async {
//     setState(() {
//       _isButtonUnavailable = true;
//     });
//     if (_device == null) {
//       show('No device selected');
//     } else {
//       if (!isConnected) {
//         await BluetoothConnection.toAddress(_device.address)
//             .then((_connection) {
//           print('Connected to the device');
//           connection = _connection;
//           setState(() {
//             _connected = true;
//           });

//           connection.input!.listen(null).onDone(() {
//             if (isDisconnecting) {
//               print('Disconnecting locally!');
//             } else {
//               print('Disconnected remotely!');
//             }
//             if (mounted) {
//               setState(() {});
//             }
//           });
//         }).catchError((error) {
//           print('Cannot connect, exception occurred');
//           print(error);
//         });
//         show('Device connected');

//         setState(() => _isButtonUnavailable = false);
//       }
//     }
//   }

//   void _disconnect() async {
//     setState(() {
//       _isButtonUnavailable = true;
//     });

//     await connection.close();
//     show('Device disconnected');
//     if (!connection.isConnected) {
//       setState(() {
//         _connected = false;
//         _isButtonUnavailable = false;
//       });
//     }
//   }




//   Future show(
//     String message, {
//     Duration duration = const Duration(seconds: 3),
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 100));
//     // ignore: deprecated_member_use
//     _scaffoldKey.currentState?.showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//         ),
//         duration: duration,
//       ),
//     );
//   }
// }
