import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart' as ble5;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'remoteControl.dart';

final ble5.FlutterBlue flutterBlue = ble5.FlutterBlue.instance;
final List<ble5.BluetoothDevice> devicesList = <ble5.BluetoothDevice>[];
final Map<ble5.Guid, List<int>> readValues = <ble5.Guid, List<int>>{};
ble5.BluetoothDevice? connectedDevice;
List<ble5.BluetoothService>? bluetoothServices;

class ble {
  void _connect() {
    ble5.BluetoothDeviceState.disconnected;
  }
}
