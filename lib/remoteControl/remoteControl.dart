import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:peppermintrc/remoteControl/globals.dart';
import 'package:peppermintrc/remoteControl/speedLimiter.dart';

class RemoteControl extends StatefulWidget {
  const RemoteControl({
    Key? key,
  }) : super(key: key);

  @override
  State<RemoteControl> createState() => _RemoteControlState();

  static getPairedDeviceList() {}
}

BluetoothConnection? connection;

class _RemoteControlState extends State<RemoteControl> {
  /*All variables*/

  String disp = "";
  double increment = 0;
  double? sendval;
  double? sendvalf;
  bool _check = true;
  bool _checkrun = true;
  late Timer _timer;
  final bool _visible = false;
  BluetoothState? _bluetoothState = BluetoothState.UNKNOWN;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  bool get isConnected => connection != null && connection!.isConnected;
  bool isDisconnecting = false;
  List<BluetoothDevice> _pairedDeviceList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _bluetoothSwitch = false;
  bool _btnState = false;
  var deviceState = 0;

  final _operationDir = GlobalSingleton().getOperationDir();
  final _drivestatus = GlobalSingleton().getDriveStatus();

  /*All variables*/

  @override
  void initState() {
    super.initState();

    getPairedDeviceList();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    //checking for bluetooth state

    GlobalSingleton()
        .enableBluetooth(); //turning the bluetooth on code is in globals.dart

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _bluetoothSwitch = true;
        }
        getPairedDeviceList();
      });
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }

    super.dispose();
  }

  Future<void> getPairedDeviceList() async {
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
      _pairedDeviceList = devices;
    });
  }

  //Actual widget start
  @override
  Widget build(BuildContext context) {
    bool _btnState1 = false;
    return Scaffold(
        key: _scaffoldKey,
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(0),
                      child: DropdownButton(
                        autofocus: true,
                        alignment: Alignment.center,
                        elevation: 1,
                        disabledHint: const Text("Turn On Switch"),
                        hint: !isConnected
                            ? const Text("Select Robot")
                            : const Text("Select Robot"),
                        isExpanded: false,
                        items: _getDeviceItems(),
                        onChanged: (value) =>
                            setState(() => _device = value as BluetoothDevice?),
                        value: _pairedDeviceList.isNotEmpty && isConnected
                            ? _device
                            : null,
                      )),
                  Row(children: [
                    Padding(
                        padding: const EdgeInsets.all(0),
                        child: Icon(
                          Icons.bluetooth_disabled,
                          color: !_bluetoothState!.isEnabled
                              ? Colors.red
                              : Colors.transparent,
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Switch(
                          inactiveTrackColor: Colors.red,
                          activeTrackColor: Colors.green,
                          activeColor: Colors.white,
                          value: _bluetoothState!.isEnabled,
                          onChanged: (bool value) {
                            future() async {
                              if (value) {
                                await FlutterBluetoothSerial.instance
                                    .requestEnable();
                              } else {
                                await FlutterBluetoothSerial.instance
                                    .requestDisable();
                              }

                              await getPairedDeviceList();
                              _bluetoothSwitch = false;
                              if (_connected) {
                                _disconnect();
                              }
                            }

                            future().then((_) {
                              setState(() {});
                            });
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.all(0),
                        child: Icon(
                          !isConnected
                              ? Icons.bluetooth_disabled
                              : Icons.bluetooth_audio_rounded,
                          color: _bluetoothState!.isEnabled && !isConnected
                              ? Colors.green
                              : isConnected
                                  ? Colors.green
                                  : Colors.transparent,
                        ))
                  ]),
                  Row(
                    mainAxisSize: MainAxisSize.min,
/*
The Speed limiter Button and the peppermint Logo  and 
the Forward and Reverse gear are place in a Row Within the main column of the app.
 */
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(width: 1),
                                  AbsorbPointer(
                                      absorbing: isConnected ? false : true,
                                      child: const SpeedLimiter()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Ink(
                                  width: 100,
                                  height: 100.0,
                                  decoration: ShapeDecoration(
                                    color: isConnected
                                        ? Colors.transparent
                                        : Colors.transparent,
                                    shape: const CircleBorder(),
                                  ),
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      child: const Text("ON/OFF"))),
                            ],
                          )),
                      AbsorbPointer(
                          absorbing: isConnected &&
                                  !_bluetoothSwitch &&
                                  _btnState == true
                              ? false
                              : true,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 10,
                              ),
                              child:
/*
This part of the code must be replaced by the two forward and reverse button
*/
                                  Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: IconButton(
                                      icon: const Icon(
                                          Icons.keyboard_arrow_up_rounded),
                                      color: Colors.grey,
                                      alignment: AlignmentDirectional.topEnd,
                                      iconSize: 40,
                                      onPressed: () {
                                        GlobalSingleton()
                                            .command(GlobalSingleton().fwdCmd);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 40, bottom: 0),
                                    child: IconButton(
                                      color: Colors.grey,
                                      alignment: AlignmentDirectional.bottomEnd,
                                      iconSize: 40,
                                      onPressed: () {
                                        GlobalSingleton()
                                            .command(GlobalSingleton().revCmd);
                                      },
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_rounded),
                                    ),
                                  )
                                ],
                              )
/*Marker */
                              ))
                    ],
                  ),

/*
The Traction power Button at the bottom of the screen
*/
                ],
              ),
/*
Code of the rigth column of the app.
It inclurdes the battery status indicator and the Joystick that we use to control the Robot
*/
              Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 350,
                            width: 240,
                            child: Scaffold(
                                appBar: AppBar(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  actions: <Widget>[
                                    Icon(Icons.battery_0_bar,
                                        color:
                                            isConnected ? Colors.green : null),
                                    isConnected
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Text(
                                              "$_btrystat%",
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ))
                                        : const Text(''),
                                    Icon(Icons.speed,
                                        color: isConnected
                                            ? const Color.fromARGB(
                                                255, 76, 175, 80)
                                            : null),
                                    isConnected
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Text(
                                              _aSpeed,
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ))
                                        : const Text(''),
                                    Icon(Icons.speed_rounded,
                                        color:
                                            isConnected ? Colors.green : null),
                                    isConnected
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Text(
                                              _relSpeed,
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ))
                                        : const Text(''),
                                    Icon(Icons.bus_alert,
                                        color:
                                            isConnected ? Colors.green : null),
                                    isConnected
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Text(
                                              _modbus,
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ))
                                        : const Text(''),
                                  ],
                                ),
                                body: SizedBox(
                                    height: 300,
                                    width: 240,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 8),
                                      child: Joystick(onStickDragEnd: () {
                                        GlobalSingleton().command(GlobalSingleton()
                                            .joystickStopCmd); //movement stop (by default)
                                      }, listener: (details) {
                                        if (isConnected) {
                                          HapticFeedback.heavyImpact();
                                          setState(() {
                                            double _x = 0;
                                            double _y = 0;
                                            sendvalf = Model().save();

                                            _x = (sendvalf! * details.x);
                                            _y = (sendvalf! * details.y);

                                            double degree =
                                                atan2(details.y, details.x);
                                            String text =
                                                "MOONS+JSR${GlobalSingleton().offsetJoystickLogic(details.x, details.y, _x, _y, degree)}";
                                            GlobalSingleton().command(text);
                                          });
                                        } else {
                                          GlobalSingleton().command(
                                              GlobalSingleton()
                                                  .joystickStopCmd); //movement stop (by default)
                                        }
                                      }),
                                    ))),
                          )
                        ])
                  ])
            ],
          ),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: IconButton(
                      iconSize: 500,
                      onPressed: () {},
                      icon: Image.asset("asset/peppermintLogo.png")),
                )
              ])
        ]));
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];

    if (_pairedDeviceList.isEmpty) {
    } else {
      _pairedDeviceList.forEach((device) {
        if (device.type == BluetoothDeviceType.classic &&
                device.name!.contains("SD") ||
            device.name!.contains("TUG")) {
          items.add(DropdownMenuItem(
            alignment: Alignment.center,
            onTap: _bluetoothSwitch
                ? null
                : _connected
                    ? _disconnect
                    : _connect,
            child: Text(device.name.toString()),
            value: device,
          ));
        }

        if (device.type == BluetoothDeviceType.le &&
                device.name!.contains("SD") ||
            device.name!.contains("TUG")) {
          items.add(DropdownMenuItem(
            alignment: Alignment.center,
            child: Text("${device.name}-BLE"),
            onTap: _bluetoothSwitch
                ? null
                : _connected
                    ? _disconnect
                    : _connect,
            value: device,
          ));
        }
      });
    }
    return items;
  }

  void _connect() async {
    setState(() {
      _bluetoothSwitch = true;
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
          connection!.input!.listen(dataReceived).onDone(() {
            if (isDisconnecting) {
            } else {}
            if (mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {});

        setState(() => _bluetoothSwitch = false);
      }
    }
  }

  void _disconnect() async {
    setState(() {
      _bluetoothSwitch = true;
    });

    await connection?.close();
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _bluetoothSwitch = false;
      });
    }
  }

  String _btrystat = '';
  String _wtrLevel = '';
  String _wtrFlow = '';
  String _relSpeed = '';
  String _aSpeed = '';
  final String _modbus = '';

  List<String> dataReceived(Uint8List data) {
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
              data[i + 4],
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
              data[i + 4],
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
