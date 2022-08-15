import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:peppermintapp/remoteControl/remoteControl.dart';
// This File is a trial run in case of the failure of the old method of receiving the data from the robot

class data_receiver {
  static data_receiver? _instance;
  data_receiver._internal() {
    _instance = this;
  }
  factory data_receiver() => _instance ?? data_receiver();
  @override
  void initState() {
    receiver();
  }

  void receiver() {
    connection!.input!.listen((event) => print(event));
  }
}
