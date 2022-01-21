import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'controller_widgets/forward_reverse_button.dart';
import 'controller_widgets/speed_controller_buttons.dart';
import 'detail_widget/obsticle_indication.dart';

void main() => runApp(const PeppermintRemote());

class PeppermintRemote extends StatelessWidget {
  const PeppermintRemote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: RemoteControl(
            title: '',
          ),
        ));
  }
}

class RemoteControl extends StatefulWidget {
  RemoteControl({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RemoteControl> createState() => _RemoteControlState();
}

class _RemoteControlState extends State<RemoteControl> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  bool get isConnected => connection != null && connection!.isConnected;
  bool isDisconnecting = false;

  BluetoothConnection? connection;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();
    getPairedDevices();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    enableBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
    }

    super.dispose();
  }

  Future _command(String data) async {
    List<int> x = List<int>.from(ascii.encode(data));

    String result = const AsciiDecoder().convert(x);
    if (connection != null) {
      connection!.output.add(ascii.encoder.convert(result));

      await connection!.output.allSent;
    }
  }

  Future<void> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
    } else {
      await getPairedDevices();
    }
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      null;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _devicesList = devices;
    });
  }

  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            key: _scaffoldKey,
            body: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (value) =>
                            setState(() => _device = value as BluetoothDevice?),
                        value: _devicesList.isNotEmpty ? _device : null,
                        onTap: _isButtonUnavailable
                            ? null
                            : _connected
                                ? _disconnect
                                : _connect),
                    Switch(
                      value: _bluetoothState.isEnabled,
                      onChanged: (bool value) {
                        future() async {
                          if (value) {
                            await FlutterBluetoothSerial.instance
                                .requestEnable();
                          } else {
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
                          }

                          await getPairedDevices();
                          _isButtonUnavailable = false;

                          if (_connected) {
                            _disconnect();
                          }
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Padding(
                            padding: EdgeInsets.all(15),
                            child: SpeedControllerWidget()),
                        Padding(padding: EdgeInsets.all(15), child: Obstacle()),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 15,
                          ),
                          child: ForwardReverseButton(),
                        )
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 9),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.all(5),
                          child: SlidingSwitch(
                            value: _value,
                            width: 150,
                            onChanged: (value) => setState(() {
                              String c1 = "MOONS+ON;";
                              String c2 = "MOONS+ME;";

                              _value = value;
                              if (value = true) {
                                HapticFeedback.heavyImpact();
                                const _powerOncmd = Duration(milliseconds: 333);
                                Timer.periodic(
                                    _powerOncmd, (Timer t) => _command(c1));
                                const _driveOncmd = Duration(milliseconds: 100);
                                Timer.periodic(
                                    _driveOncmd, (Timer t) => _command(c2));
                              } else {
                                null;
                              }
                            }),
                            height: 40,
                            animationDuration: const Duration(milliseconds: 40),
                            onTap: () {},
                            onDoubleTap: () {},
                            onSwipe: () {},
                            textOff: "OFF",
                            textOn: "ON",
                            colorOn: const Color(0xff64dd17),
                            colorOff: const Color(0xffdd2c00),
                            background: const Color(0xffe4e5eb),
                            buttonColor: const Color(0xfff7f5f7),
                            inactiveColor: const Color(0xff636f7b),
                          ),
                        ))
                  ],
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 300,
                        width: 240,
                        child: Joystick(listener: (details) {
                          setState(() {
                            double _x = 50;
                            double _y = 50;
                            const step = 10;

                            _x = _x + step * details.x;
                            _y = _y + step * details.y;
                            double r = sqrt(_x * _x + _y * _y);

                            var s = r.toStringAsFixed(0);
                            var theta = atan(_y / _x);
                            theta = (180 * (theta / pi));
                            var stheta = theta.toStringAsFixed(0);

                            final String text = "MOONS+JSR${s}A$stheta;";
                            _command(text);
                          });
                        }),
                      ),
                    ])
              ],
            )));
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('Choose Robot'),
      ));
    } else {
      for (var device in _devicesList) {
        items.add(DropdownMenuItem(
          child: Text(device.name.toString()),
          value: device,
        ));
      }
    }
    return items;
  }

  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device!.address)
            .then((_connection) {
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection!.input!.listen(null).onDone(() {
            if (isDisconnecting) {
            } else {}
            if (mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {});

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
    });

    await connection?.close();
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }
}




/*  Dialogbox to be considered in v0.6 */


// _showRobotList(BuildContext context) {
//   return showDialog(
//       barrierDismissible: true,
//       context: context,
//       builder: (BuildContext context) {
//         return SizedBox(
//             child: AlertDialog(
//                 insetPadding: const EdgeInsets.only(
//                     left: 40, top: 10, right: 40, bottom: 20),
//                 title: const Text(
//                   "Robot List",
//                   textAlign: TextAlign.center,
//                 ),
//                 content: SizedBox(
//                     height: 400,
//                     width: 600,
//                     child:
//                         //  DiscoveryPage()
//                         BluetoothApp())));
//       });
// }
