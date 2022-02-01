import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:sliding_switch/sliding_switch.dart';

import 'detail_widget/obsticle_indication.dart';
import 'forward_reverse_button.dart';
import 'speed_controller_buttons.dart';

void main() => runApp(const PeppermintRemote());

class PeppermintRemote extends StatelessWidget {
  const PeppermintRemote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: RemoteControl(),
        ));
  }
}

class RemoteControl extends StatefulWidget {
  const RemoteControl({Key? key}) : super(key: key);

  @override
  State<RemoteControl> createState() => _RemoteControlState();
}

BluetoothConnection? connection;

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
  bool _isButtonUnavailable = true;

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

  Future command(String data1) async {
    List<int> x = List<int>.from(ascii.encode(data1));

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
                      children: <Widget>[
                        const Padding(
                            padding: EdgeInsets.all(15),
                            child: SpeedControllerWidget()),
                        const Padding(
                            padding: EdgeInsets.all(15), child: Obstacle()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 15,
                          ),
                          child: ForwardReverseButton(context),
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
                              String c3 = "MOONS+OFF;";
                              String c4 = "MOONS+MD;";

                              _value = value;
                              if (value = true) {
                                HapticFeedback.heavyImpact();
                                const _powerOncmd = Duration(milliseconds: 333);

                                Timer.periodic(
                                    _powerOncmd, (Timer t) => command(c1));

                                const _driveOncmd = Duration(milliseconds: 100);
                                Timer.periodic(
                                    _driveOncmd, (Timer t) => command(c2));
                              } else {
                                _disconnect;
                                HapticFeedback.heavyImpact();
                                const _powerOffCmd =
                                    Duration(milliseconds: 333);
                                Timer.periodic(
                                    _powerOffCmd, (Timer t) => command(c3));
                                const _driveOffcmd =
                                    Duration(milliseconds: 100);
                                Timer.periodic(
                                    _driveOffcmd, (Timer t) => command(c4));
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 350,
                                width: 240,
                                child: Scaffold(
                                  appBar: AppBar(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    actions: <Widget>[
                                      Icon(Icons.bluetooth_connected,
                                          color: connection != null &&
                                                  connection!.isConnected
                                              ? Colors.green
                                              : null),
                                      const Spacer(),
                                      Icon(Icons.battery_charging_full,
                                          color: connection != null &&
                                                  connection!.isConnected
                                              ? Colors.green
                                              : null),
                                      connection != null &&
                                              connection!.isConnected
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Text(
                                                _btrystat + "%",
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ))
                                          : const Text(''),
                                      Icon(Icons.invert_colors,
                                          color: connection != null &&
                                                  connection!.isConnected
                                              ? Colors.green
                                              : null),
                                      connection != null &&
                                              connection!.isConnected
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Text(
                                                _wtrLevel + "%",
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ))
                                          : const Text(''),
                                      Icon(Icons.water,
                                          color: connection != null &&
                                                  connection!.isConnected
                                              ? Colors.green
                                              : null),
                                      connection != null &&
                                              connection!.isConnected
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Text(
                                                _wtrFlow,
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ))
                                          : const Text(''),
                                      Icon(Icons.cleaning_services,
                                          color: connection != null &&
                                                  connection!.isConnected
                                              ? Colors.green
                                              : null),
/*Additional debugging features*/

                                      // connection != null &&
                                      //         connection!.isConnected
                                      //     ? Padding(
                                      //         padding: const EdgeInsets.only(
                                      //             top: 20),
                                      //         child: Text(
                                      //           _relSpeed,
                                      //           textAlign: TextAlign.end,
                                      //           style: const TextStyle(
                                      //               color: Colors.black),
                                      //         ))
                                      //     : const Text(''),
                                      // connection != null &&
                                      //         connection!.isConnected
                                      //     ? Padding(
                                      //         padding: const EdgeInsets.only(
                                      //             top: 20),
                                      //         child: Text(
                                      //           _aSpeed,
                                      //           textAlign: TextAlign.end,
                                      //           style: const TextStyle(
                                      //               color: Colors.black),
                                      //         ))
                                      //     : const Text(''),
                                    ],
                                  ),
                                  body: SizedBox(
                                    height: 300,
                                    width: 240,
                                    child: Joystick(listener: (details) {
                                      setState(() {
                                        double _x = 10;
                                        double _y = 10;
                                        double step = 3;
                                        HapticFeedback.heavyImpact();

                                        _x = step * details.x;
                                        _y = step * details.y;

                                        double r = sqrt(pow(_x, 2).toInt() +
                                            pow(_y, 2).toInt());

                                        var s = r.toStringAsFixed(0);
                                        double theta = atan(_y / _x);

                                        double radians = (180 * (theta / pi));
                                        String text = "MOONS+JSR${s}A$radians;";
                                        command(text);
                                      });
                                    }),
                                  ),
                                ))
                          ])
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

          connection!.input!.listen(onDataReceived).onDone(() {
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

  String _btrystat = '';
  String _wtrLevel = '';
  String _wtrFlow = '';
  String _relSpeed = '';
  String _aSpeed = '';

  List<String> onDataReceived(Uint8List data) {
    int backspacesCounter = 0;
    String? batStatus;
    String? waterStat;
    String? waterFlow;
    String? refspeed;
    String? speed;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }

    Uint8List proxy = Uint8List(data.length - backspacesCounter);
    int proxyIndex = proxy.length;
    backspacesCounter = 0;

    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
        } else {
          proxy[--proxyIndex] = data[i];
          if (data[i] == 86 && data[i - 1] == 42) {
            List<int> batstatus = List<int>.from([
              data[i + 1],
              data[i + 2],
              data[i + 3],
              data[i + 4],
            ]);
            String result = const AsciiDecoder().convert(batstatus);
            setState(() {
              batStatus = result;
              _btrystat = batStatus!;
            });
          }
          if (data[i] == 119 && data[i - 1] == 42) {
            List<int> wtrlevel = List<int>.from([
              data[i + 1],
              data[i + 2],
              data[i + 3],
              data[i + 4],
            ]);
            String result = const AsciiDecoder().convert(wtrlevel);
            setState(() {
              waterStat = result;
              _wtrLevel = waterStat!;
            });
          }
          if (data[i] == 89 && data[i - 1] == 42) {
            List<int> wtrFlow = List<int>.from([
              data[i + 1],
              data[i + 2],
              data[i + 3],
            ]);
            String result = const AsciiDecoder().convert(wtrFlow);
            setState(() {
              waterFlow = result;
              _wtrFlow = waterFlow!;
            });
          }
          if (data[i] == 74 && data[i - 1] == 42) {
            List<int> refSpeed = List<int>.from([
              data[i + 1],
              data[i + 2],
              data[i + 3],
            ]);
            String result = const AsciiDecoder().convert(refSpeed);
            setState(() {
              refspeed = result;
              _relSpeed = refspeed!;
            });
          }
          if (data[i] == 73 && data[i - 1] == 42) {
            List<int> aSpeed = List<int>.from([
              data[i + 1],
              data[i + 2],
              data[i + 3],
            ]);
            String result = const AsciiDecoder().convert(aSpeed);
            setState(() {
              speed = result;
              _aSpeed = speed!;
            });
          }
        }
      }
    }
    return [waterFlow.toString(), waterStat.toString(), batStatus.toString()];
  }
}
