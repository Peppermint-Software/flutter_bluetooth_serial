import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:peppermintapp/remoteControl/helpers.dart';

class DiagnosticsMain extends StatefulWidget {
  const DiagnosticsMain({Key? key}) : super(key: key);

  @override
  State<DiagnosticsMain> createState() => _DiagnosticsMainState();
}

class _DiagnosticsMainState extends State<DiagnosticsMain> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return MaterialApp(
        home: Scaffold(
            appBar: GFAppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.white30,
              bottomOpacity: 0,
              title: const Text(
                "Diagnostics",
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                Icon(
                  Icons.circle,
                  size: 24,
                  color: isConnected ? Colors.green : Colors.red,
                )
              ],
            ),
            body: Column(children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) => GFAccordion(
                            collapsedIcon: const Icon(
                              Icons.arrow_drop_down_circle_rounded,
                              color: Colors.grey,
                            ),
                            contentChild: placeholder(context),
                            showAccordion: true,
                            contentPadding: const EdgeInsets.all(8),
                            title: titleList[index].toString(),
                          ))),
            ])));
  }
}

var titleList = {0: "General Info", 1: "Cleaning Data", 2: "Motor Data"};

Widget placeholder(context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40), // if you need this
      side: BorderSide(
        color: Colors.grey.withOpacity(0.2),
        width: 1,
      ),
    ),
    child: Container(
      color: Colors.white,
      width: 200,
      height: 200,
      child: Column(
        children: <Widget>[
          Text(
            titleList.toString(),
          ),
          const Spacer(),
          Text(something.toString()),
        ],
      ),
    ),
  );
}

List<Map<String, dynamic>> something = [
  {
    "Firmware Version": true,
    "Modbus Connection Status": " Connected",
    "E Stop Engaged: ": true
  },
  {"Placeholder": "Lorem epsum", "Something 1": "Lorem epsum 2"}
];
String _btrystat = '';
String _wtrLevel = '';
String _wtrFlow = '';
String _relSpeed = '';
String _aSpeed = '';
final String _modbus = '';

// List<String> dataReceived(Uint8List data) {
//   int backspacesCounter = 0;
//   String? batStatus;
//   String? waterStat;
//   String? waterFlow;
//   String? refspeed;
//   String? speed;
//   for (var byte in data) {
//     if (byte == 8 || byte == 127) {
//       backspacesCounter++;
//     }
//   }

//   Uint8List proxy = Uint8List(data.length - backspacesCounter);
//   int proxyIndex = proxy.length;
//   backspacesCounter = 0;
//   for (int i = data.length - 1; i >= 0; i--) {
//     if (data[i] == 8 || data[i] == 127) {
//       backspacesCounter++;
//     } else {
//       if (backspacesCounter > 0) {
//       } else {
//         proxy[--proxyIndex] = data[i];
//         if (data[i] == 86 && data[i - 1] == 42) {
//           List<int> wtrlevel = List<int>.from([
//             data[i + 1],
//             data[i + 2],
//             data[i + 3],
//             data[i + 4],
//           ]);
//           String result = const AsciiDecoder().convert(wtrlevel);
//           setState(() {
//             waterStat = result;
//             _wtrLevel = waterStat!;
//           });
//         }
//         print(proxy);
//         if (data[i] == 89 && data[i - 1] == 42) {
//           List<int> wtrFlow = List<int>.from([
//             data[i + 1],
//             data[i + 2],
//             data[i + 3],
//           ]);
//           String result = const AsciiDecoder().convert(wtrFlow);
//           setState(() {
//             waterFlow = result;
//             _wtrFlow = waterFlow!;
//           });
//         }

//         if (data[i] == 74 && data[i - 1] == 42) {
//           List<int> refSpeed = List<int>.from([
//             data[i + 1],
//             data[i + 2],
//             data[i + 3],
//             data[i + 4],
//           ]);
//           String result = const AsciiDecoder().convert(refSpeed);
//           setState(() {
//             refspeed = result;
//             _relSpeed = refspeed!;
//           });
//         }

//         if (data[i] == 73 && data[i - 1] == 42) {
//           List<int> aSpeed = List<int>.from([
//             data[i + 1],
//             data[i + 2],
//             data[i + 3],
//             data[i + 4],
//           ]);
//           String result = const AsciiDecoder().convert(aSpeed);
//           setState(() {
//             speed = result;
//             _aSpeed = speed!;
//           });
//         }
//       }
//     }
//   }
//   return [waterFlow.toString(), waterStat.toString(), batStatus.toString()];
// }
