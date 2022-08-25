import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:peppermintapp/customButton.dart';
import 'package:peppermintapp/dataReceiver.dart';
import 'package:peppermintapp/diagnosticsMode/diagnosticsMain.dart';
import 'package:peppermintapp/remoteControl/globals.dart';
import 'package:peppermintapp/remoteControl/speedLimiter.dart';
import 'package:test/test.dart';

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
  late bool onOffswap = true;
  late bool frswap = true;
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
  late final BluetoothBondState _bondingState = BluetoothBondState.bonding;
  var deviceState = 0;
  Uint8List bytes = Uint8List.fromList([0, 58, 0, 56, 654, 78]);

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

    GlobalSingleton()
        .enableBluetooth(); //turning the bluetooth on code is in globals.dart
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {}
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Scaffold(
        key: _scaffoldKey,
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DropdownButton(
                    autofocus: true,
                    alignment: Alignment.center,
                    disabledHint: const Text("Enable Bluetooth"),
                    hint: !isConnected
                        ? const Text(
                            "Select Robot",
                            style: TextStyle(color: Colors.black),
                          )
                        : const Text("Select Robot"),
                    isExpanded: false,
                    items: _getDeviceItems(),
                    onChanged: (value) =>
                        {setState(() => _device = value as BluetoothDevice?)},
                    value: _pairedDeviceList.isNotEmpty && isConnected
                        ? _device
                        : null,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
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
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Ink(
                                  child: AbsorbPointer(
                                absorbing: isConnected ? false : true,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: CustomButton(onPressed: () {})),
                                // ElevatedButton(
                                //     onPressed: () {
                                //       setState(() {
                                //         onOffswap = !onOffswap;
                                //       });
                                //       switch (onOffswap) {
                                //         case true:
                                //           {
                                //             HapticFeedback.heavyImpact();
                                //             const powerOnCmd = Duration(
                                //                 milliseconds: 333);
                                //             GlobalSingleton().onTimerVar =
                                //                 Timer.periodic(
                                //                     powerOnCmd,
                                //                     (Timer t) => GlobalSingleton()
                                //                         .command(
                                //                             GlobalSingleton()
                                //                                 .driveOn));
                                //             GlobalSingleton().command(
                                //                 GlobalSingleton()
                                //                     .motorOn);
                                //             GlobalSingleton()
                                //                 .offTimerVar
                                //                 .cancel();

                                //             break;
                                //           }
                                //         case false:
                                //           {
                                //             HapticFeedback.heavyImpact();
                                //             GlobalSingleton()
                                //                 .onTimerVar
                                //                 .cancel();

                                //             GlobalSingleton().command(
                                //                 GlobalSingleton()
                                //                     .motorOff);

                                //             GlobalSingleton().command(
                                //                 GlobalSingleton()
                                //                     .driveOff);
                                //             break;
                                //           }
                                //       }
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //         primary: const Color.fromARGB(
                                //             255, 235, 16, 16),
                                //         onPrimary: const Color.fromARGB(
                                //             255, 255, 255, 255),
                                //         shape: const CircleBorder(),
                                //         padding:
                                //             const EdgeInsets.all(30)),
                                //     child: onOffswap == true
                                //         ? Icon(
                                //             Icons
                                //                 .power_settings_new_outlined,
                                //             color: onOffswap
                                //                 ? Colors.green
                                //                 : Colors.white,
                                //           )
                                //         : const Icon(
                                //             Icons
                                //                 .power_settings_new_outlined,
                                //             color: Colors.white,
                                //           ))
                              )),
                            ],
                          )),
                      AbsorbPointer(
                          absorbing: isConnected ? false : true,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        frswap = true;
                                        GlobalSingleton()
                                            .command(GlobalSingleton().fwdCmd);
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: frswap
                                          ? const Color.fromARGB(
                                              255, 76, 175, 80)
                                          : const Color.fromARGB(
                                              255, 158, 158, 158),
                                      shape: const CircleBorder(),
                                      shadowColor: Colors.black12,
                                      padding: const EdgeInsets.all(10),
                                    ),
                                    child: const Text(
                                      "F",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 80, bottom: 0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          frswap = false;
                                          GlobalSingleton().command(
                                              GlobalSingleton().revCmd);
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: frswap
                                            ? Color.fromARGB(255, 250, 249, 249)
                                            : const Color.fromARGB(
                                                255, 76, 175, 80),
                                        shape: const CircleBorder(),
                                        shadowColor: Colors.black12,
                                        padding: const EdgeInsets.all(10),
                                      ),
                                      child: const Text(
                                        "R",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ),
                                  )
                                ],
                              )))
                    ],
                  ),
                ],
              ),
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
                              height: 290,
                              width: 240,
                              child: Scaffold(
                                  appBar: AppBar(
                                    leading: Icon(Icons.bluetooth,
                                        size: 30,
                                        color: _bondingState.isBondingStatus()
                                            ? Colors.yellow
                                            : _bondingState.isBonded
                                                ? Colors.green
                                                : Colors.blue),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    actions: <Widget>[
                                      Icon(Icons.battery_0_bar,
                                          color: isConnected
                                              ? Colors.green
                                              : Colors.transparent),
                                      isConnected
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Text(
                                                "$_btrystat%",
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ))
                                          : const Text(''),
                                      Icon(Icons.invert_colors,
                                          color: isConnected
                                              ? const Color.fromARGB(
                                                  255, 76, 175, 80)
                                              : Colors.transparent),
                                      isConnected
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Text(
                                                _wtrLevel,
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ))
                                          : const Text(''),
                                      Icon(Icons.speed_rounded,
                                          color: isConnected
                                              ? Colors.green
                                              : Colors.transparent),
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
                                    ],
                                  ),
                                  body: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0),
                                    child: SizedBox.expand(
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
                                        GlobalSingleton().command(GlobalSingleton()
                                            .joystickStopCmd); //movement stop (by default)
                                      }
                                    })),
                                  ))),
                        ])
                  ])
            ],
          ),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Ink(
                    height: 80,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          readJson();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DiagnosticsMain()));
                        },
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 255, 255, 255)),
                        icon: const ImageIcon(
                          AssetImage(
                            "asset/peppermintLogo.png",
                          ),
                          color: Colors.green,
                          size: 70,
                        ),
                        label: const Text("")))
              ])
        ]));
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];

    if (_pairedDeviceList.isEmpty) {
    } else {
      _pairedDeviceList.forEach((device) {
        if (device.type == BluetoothDeviceType.classic
            // &&
            //         device.name!.contains("SD") ||
            //     device.name!.contains("TUG")
            ) {
          items.add(DropdownMenuItem(
            alignment: Alignment.center,
            onTap: _connected == false ? connect : _disconnect,
            value: device,
            child: Text(device.name.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontStyle: FontStyle.normal)),
          ));
        }
      });
    }
    return items;
  }

  void connect() async {
    if (_device == null) {
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device!.address).then((con) {
          setState(() {
            _connected = true;
            connection = con;
            const powerOnCmd = Duration(milliseconds: 333);
            connection!.input!.listen(dataReceived).onDone(() {
              if (isDisconnecting) {
              } else {}
              if (mounted) {
                setState(() {});
              }
            });
            GlobalSingleton().onTimerVar = Timer.periodic(
                powerOnCmd,
                (Timer t) =>
                    GlobalSingleton().command(GlobalSingleton().driveOn));
            GlobalSingleton().command(GlobalSingleton().motorOn);
            GlobalSingleton().offTimerVar.cancel();
          });
        }).catchError((error) {});
      }
    }
  }

  void _disconnect() async {
    await connection?.close();
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        HapticFeedback.heavyImpact();
        GlobalSingleton().onTimerVar.cancel();

        GlobalSingleton().command(GlobalSingleton().motorOff);

        GlobalSingleton().command(GlobalSingleton().driveOff);
      });
    }
  }

  late String _btrystat = '';
  late String _wtrLevel = '';
  late String _wtrFlow = '';

  Future<dynamic> dataReceived(Uint8List data) async {
    int backspacesCounter = 0;
    late String batStatus;
    late String waterStat;
    late String waterFlow;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    void uintsort(
      int index,
      List<dynamic> data,
      int n,
      int hash,
    ) {
      if (data[index] == n && data[index - 1] == hash) {
        List<int> newlist = data[index + 1];
        Iterable<int> varname =
            newlist.where((p) => p < index ? data[index] : null);
        print("varname ==>" + varname.toString());
      }
    }

    Uint8List proxy = Uint8List(data.length - backspacesCounter);
    int proxyIndex = proxy.length;

    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter < 0) {
        } else {
          proxy[--proxyIndex] = data[i];
          uintsort(86, data, 42, i);
          if (data[i] == 86 && data[i - 1] == 42) {
            //Battery SoC "V"

            List<int> batstatus = List<int>.from([
              data[i + 1],
              data[i + 2],
              data[i + 3],
              data[i + 4],
            ]);
            String result = const AsciiDecoder().convert(batstatus);
            setState(() {
              batStatus = result;
              _btrystat = batStatus;
            });
          }
          if (data[i] == 119 && data[i - 1] == 42) {
            //Water Level 'w'
            List<int> wtrlevel = List<int>.from([
              data[i + 1],
              data[i + 2],
              data[i + 3],
              data[i + 4],
            ]);
            String result = const AsciiDecoder().convert(wtrlevel);
            setState(() {
              waterStat = result;
              _wtrLevel = waterStat;
            });
          }
          if (data[i] == 73 && data[i - 1] == 42) {
            //speed left
            List<int> wtrFlow = List<int>.from([
              data[i + 1],
              data[i + 2],
              data[i + 3],
            ]);
            String result = const AsciiDecoder().convert(wtrFlow);
            setState(() {
              waterFlow = result;
              _wtrFlow = waterFlow;
            });
          }
        }
      }
    }
  }
}
