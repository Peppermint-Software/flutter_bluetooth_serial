import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:sliding_switch/sliding_switch.dart';

void main() => runApp(const PeppermintRemote());

class PeppermintRemote extends StatelessWidget {
  const PeppermintRemote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: RemoteControl(),
        ));
  }
}

class RemoteControl extends StatefulWidget {
  const RemoteControl({
    Key? key,
  }) : super(key: key);

  @override
  State<RemoteControl> createState() => _RemoteControlState();
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
    enableBluetooth();

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

  Future command(String data1) async {
    List<int> x = List<int>.from(ascii.encode(data1));

    String result = const AsciiDecoder().convert(x);
    if (isConnected) {
      connection!.output.add(ascii.encoder.convert(result));
      await connection!.output.allSent;
    }
  }

  Future<void> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDeviceList();
    } else {
      await getPairedDeviceList();
    }
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

  @override
  Widget build(BuildContext context) {
    bool _btnState1 = false;
    return Container(
        child: Scaffold(
            key: _scaffoldKey,
            body: Row(
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
                          onChanged: (value) => setState(
                              () => _device = value as BluetoothDevice?),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            padding: const EdgeInsets.all(8),
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
                                    const SizedBox(width: 5),
                                    AbsorbPointer(
                                        absorbing: isConnected ? false : true,
                                        child: GestureDetector(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue,
                                            ),
                                            width: 40,
                                            height: 40,
                                            child: const Center(
                                              child: Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _checkrun = false;
                                              increment * 0.1 < 2
                                                  ? increment++
                                                  : increment = 1;
                                            });
                                            sendval = increment * 10;
                                            disp = (increment * 0.1)
                                                .toStringAsPrecision(1);
                                          },
                                          onTapDown: (TapDownDetails details) {
                                            _timer = Timer.periodic(
                                                const Duration(
                                                    milliseconds: 100), (t) {
                                              setState(() {
                                                _checkrun = false;

                                                increment * 0.1 < 2
                                                    ? increment++
                                                    : increment = 1;
                                              });
                                              sendval = increment * 10;

                                              disp = (increment * 0.1)
                                                  .toStringAsPrecision(1);
                                            });
                                          },
                                          onTapUp: (TapUpDetails details) {
                                            _timer.cancel();
                                          },
                                          onTapCancel: () {
                                            _timer.cancel();
                                          },
                                        )),
                                    Visibility(
                                        visible:
                                            !isConnected ? _visible : !_visible,
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 6),
                                            child: Text(
                                              increment == 0 ? "0.0" : disp,
                                              textDirection: TextDirection.rtl,
                                              softWrap: true,
                                              textAlign: increment == 0
                                                  ? TextAlign.right
                                                  : TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            ))),
                                    Visibility(
                                        visible: increment != 0
                                            ? !_visible
                                            : _visible,
                                        child: const Padding(
                                            padding: EdgeInsets.only(left: 7),
                                            child: Text(
                                              "m/sec",
                                              style: TextStyle(fontSize: 9),
                                              textAlign: TextAlign.end,
                                            ))),
                                    AbsorbPointer(
                                        absorbing: isConnected ? false : true,
                                        child: IconButton(
                                          alignment: Alignment.centerLeft,
                                          onPressed: () {
                                            HapticFeedback.heavyImpact();

                                            setState(() {
                                              _check = !_check;
                                              if (_check == false) {
                                                sendvalf = sendval;

                                                command("MOONS+SL$sendvalf;");
                                              }
                                              if (_check == true &&
                                                  _checkrun == false) {
                                                sendvalf = 0;

                                                command("MOONS+SL$sendvalf");
                                              }
                                            });
                                          },
                                          icon: Icon((_check == false)
                                              ? Icons.lock
                                              : Icons.lock_open),
                                        )),
                                    AbsorbPointer(
                                      absorbing: isConnected ? false : true,
                                      child: GestureDetector(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: Center(
                                            child: Container(
                                              color: Colors.white,
                                              width: 15,
                                              height: 3,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _checkrun = !_checkrun;

                                            if (increment > 0) increment--;
                                          });
                                          sendval = increment * 10;

                                          disp = (increment * 0.1)
                                              .toStringAsPrecision(1);
                                        },
                                        onTapDown: (TapDownDetails details) {
                                          _timer = Timer.periodic(
                                              const Duration(milliseconds: 100),
                                              (t) {
                                            setState(() {
                                              _checkrun = !_checkrun;

                                              if (increment > 0) increment--;
                                            });
                                            sendval = increment * 10;

                                            disp = (increment * 0.1)
                                                .toStringAsPrecision(1);
                                          });
                                        },
                                        onTapUp: (TapUpDetails details) {
                                          _timer.cancel();
                                        },
                                        onTapCancel: () {
                                          _timer.cancel();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(15),
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
                                    child: Image(
                                        fit: BoxFit.contain,
                                        color: isConnected
                                            ? Colors.teal.shade300
                                            : Colors.grey.shade400,
                                        image: const AssetImage(
                                            "asset/Leaf_grey.png"))),
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
                                horizontal: 15,
                              ),
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: SlidingSwitch(
                                  value: _btnState1,
                                  width: 180,
                                  onChanged: (bool value) => setState(() {
                                    if (isConnected) {
                                      String _frwCmd = "MOONS+F;";
                                      String _revCmd = "MOONS+R;";

                                      HapticFeedback.vibrate();

                                      value == true
                                          ? command(_revCmd)
                                          : command(_frwCmd);
                                    }
                                  }),
                                  height: 50,
                                  animationDuration:
                                      const Duration(milliseconds: 0),
                                  onTap: () {},
                                  onDoubleTap: () {},
                                  onSwipe: () {},
                                  textOff: '<',
                                  textOn: '>',
                                  colorOn: Colors.deepOrangeAccent.shade700,
                                  colorOff: Colors.lightGreenAccent.shade700,
                                  background: Colors.grey.shade300,
                                  buttonColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                ),
                              ),
                            ))
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.only(bottom: 2, top: 0),
                        child: Text("Traction Power")),
                    AbsorbPointer(
                        absorbing:
                            isConnected && !_bluetoothSwitch ? false : true,
                        child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              padding: const EdgeInsets.only(bottom: 2),
                              child: SlidingSwitch(
                                value: _btnState && _bluetoothSwitch,
                                width: 150,
                                onChanged: (value) => setState(() {
                                  if (!_bluetoothState!.isEnabled) {
                                    setState(() {
                                      _btnState == false;
                                      value = false;
                                    });
                                  }
                                  if (isConnected) {
                                    String _startDrive = "MOONS+ON;";
                                    String _enableMotor = "MOONS+ME;";
                                    String _stopDrive = "MOONS+OFF;";
                                    String _disableMotor = "MOONS+MD;";

                                    _btnState = value;

                                    if (value == true) {
                                      HapticFeedback.heavyImpact();
                                      const _powerOnCmd =
                                          Duration(milliseconds: 333);
                                      Timer.periodic(_powerOnCmd,
                                          (Timer t) => command(_startDrive));

                                      command(_enableMotor);
                                    }

                                    if (value == false) {
                                      HapticFeedback.heavyImpact();

                                      command(_disableMotor);
                                      const _powerOffCmd =
                                          Duration(milliseconds: 333);
                                      Timer.periodic(_powerOffCmd,
                                          (Timer t) => command(_stopDrive));
                                      setState(() {
                                        deviceState == 0;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      value = false;
                                    });
                                  }
                                }),
                                height: 40,
                                animationDuration:
                                    const Duration(milliseconds: 0),
                                onTap: () {},
                                onDoubleTap: () {},
                                onSwipe: () {},
                                textOff: "OFF",
                                textOn: "ON",
                                colorOn: Colors.lightGreenAccent.shade700,
                                colorOff: Colors.deepOrangeAccent.shade700,
                                background: Colors.grey.shade300,
                                buttonColor: Colors.white,
                                inactiveColor: Colors.grey,
                              ),
                            )))
                  ],
                ),
                Column(
                    mainAxisSize: MainAxisSize.max,
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
                                      Icon(Icons.battery_charging_full,
                                          color: isConnected
                                              ? Colors.green
                                              : null),
                                      isConnected
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
                                          color: isConnected
                                              ? Colors.green
                                              : null),
                                      isConnected
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
                                          color: isConnected
                                              ? Colors.green
                                              : null),
                                      isConnected
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
                                          color: isConnected
                                              ? Colors.green
                                              : null),
                                    ],
                                  ),
                                  body: SizedBox(
                                      height: 300,
                                      width: 240,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 35, horizontal: 8),
                                        child: Joystick(onStickDragEnd: () {
                                          command("MOONS+JSR0A180;");
                                          command("MOONS+JSR0A180;");
                                        }, listener: (details) {
                                          if (isConnected) {
                                            HapticFeedback.heavyImpact();

                                            StickDragDetails(0, 12);
                                            setState(() {
                                              double _x = 0;
                                              double _y = 0;

                                              _x = (sendvalf! * details.x);
                                              _y = (sendvalf! * details.y);

                                              double r = sqrt(
                                                      pow(_x, 2).toInt() +
                                                          pow(_y, 2).toInt())
                                                  .abs();
                                              double degree =
                                                  atan2(details.y, details.x);
                                              var s = r.toStringAsFixed(0);

                                              int radians =
                                                  (180 * (degree / pi)).toInt();
                                              radians >= 1 && radians <= 180
                                                  ? radians = radians + 90
                                                  : (radians <= -1 &&
                                                          radians >= -90)
                                                      ? radians = 90 + radians
                                                      : (radians < -90 &&
                                                              radians >= -180)
                                                          ? radians =
                                                              450 + radians
                                                          : radians;
                                              int number = radians.toInt();
                                              String text =
                                                  "MOONS+JSR${s}A$number;";

                                              command(text);
                                            });
                                          } else {
                                            command("MOONS+JSR0A180;");
                                          }
                                        }),
                                      ))),
                            )
                          ])
                    ])
              ],
            )));
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_pairedDeviceList.isEmpty) {
    } else {
      _pairedDeviceList.forEach((device) {
        if (device.name!.contains("SD") || device.name!.contains("TUG")) {
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

    await connection!.close();
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
