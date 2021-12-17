import 'dart:async';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class RobotList extends StatefulWidget {
  const RobotList({Key? key}) : super(key: key);

  @override
  _RobotListState createState() => _RobotListState();
}

class _RobotListState extends State<RobotList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FlutterBluetoothSerial.instance.requestEnable(),
        builder: (context, future) {
          if (future.connectionState == ConnectionState.waiting) {
            return Container(
              child: const Center(
                child: Icon(
                  Icons.bluetooth_disabled_rounded,
                  size: 100,
                  color: Colors.black12,
                ),
              ),
            );
          } else {
            return Container(child: getresult());
          }
        });
  }
}

void getresult() {
  var results;
  results = <BluetoothDiscoveryResult>[];

  void startDiscovery() {
    var streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      results.add(r);
    });

    streamSubscription.onDone(() {
      //Do something when the discovery process ends
    });
  }
}

// class Widget2 extends StatefulWidget {
//   const Widget2({Key? key}) : super(key: key);

//   @override
//   _Widget2State createState() => _Widget2State();
// }

// class _Widget2State extends State<Widget2> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SelectBondedDevicePage(onCahtPage: (device1) {
//         BluetoothDevice device = device1;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) {},
//           ),
//         );
//       }),
//     );
//   }
// }

// class SelectBondedDevicePage extends StatefulWidget {
//   /// If true, on page start there is performed discovery upon the bonded devices.
//   /// Then, if they are not avaliable, they would be disabled from the selection.
//   final bool checkAvailability;
//   final Function onCahtPage;

//   const SelectBondedDevicePage(
//       {this.checkAvailability = true, @required this.onCahtPage});

//   @override
//   _SelectBondedDevicePage createState() => new _SelectBondedDevicePage();
// }

// enum _DeviceAvailability {
//   no,
//   maybe,
//   yes,
// }

// class _DeviceWithAvailability extends BluetoothDevice {
//   BluetoothDevice device;
//   _DeviceAvailability availability;
//   int rssi;

//   _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
// }

// class _SelectBondedDevicePage extends State<SelectBondedDevicePage> {
//   List<_DeviceWithAvailability> devices = List<_DeviceWithAvailability>();

//   // Availability
//   StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;
//   bool _isDiscovering;

//   _SelectBondedDevicePage();

//   @override
//   void initState() {
//     super.initState();

//     _isDiscovering = widget.checkAvailability;

//     if (_isDiscovering) {
//       _startDiscovery();
//     }

//     // Setup a list of the bonded devices
//     FlutterBluetoothSerial.instance
//         .getBondedDevices()
//         .then((List<BluetoothDevice> bondedDevices) {
//       setState(() {
//         devices = bondedDevices
//             .map(
//               (device) => _DeviceWithAvailability(
//                 device,
//                 widget.checkAvailability
//                     ? _DeviceAvailability.maybe
//                     : _DeviceAvailability.yes,
//               ),
//             )
//             .toList();
//       });
//     });
//   }

//   void _restartDiscovery() {
//     setState(() {
//       _isDiscovering = true;
//     });

//     _startDiscovery();
//   }

//   void _startDiscovery() {
//     _discoveryStreamSubscription =
//         FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
//       setState(() {
//         Iterator i = devices.iterator;
//         while (i.moveNext()) {
//           var _device = i.current;
//           if (_device.device == r.device) {
//             _device.availability = _DeviceAvailability.yes;
//             _device.rssi = r.rssi;
//           }
//         }
//       });
//     });

//     _discoveryStreamSubscription.onDone(() {
//       setState(() {
//         _isDiscovering = false;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     // Avoid memory leak (`setState` after dispose) and cancel discovery
//     _discoveryStreamSubscription.cancel();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<BluetoothDeviceListEntry> list = devices
//         .map(
//           (_device) => BluetoothDeviceListEntry(
//             device: _device.device,
//             // rssi: _device.rssi,
//             // enabled: _device.availability == _DeviceAvailability.yes,
//             onTap: () {
//               widget.onCahtPage(_device.device);
//             },
//           ),
//         )
//         .toList();
//     return ListView(
//       children: list,
//     );
//   }
// }
