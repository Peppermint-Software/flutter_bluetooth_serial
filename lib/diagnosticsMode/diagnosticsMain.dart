import 'dart:convert';
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
                  Icons.arrow_back,
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
                            contentChild: contentholder(context),
                            showAccordion: false,
                            contentPadding: const EdgeInsets.all(8),
                            title: titleList[index].toString(),
                          ))),
            ])));
  }
}

var titleList = {0: "General Info", 1: "Cleaning Data", 2: "Motor Data"};
List _items = [];
List _items2 = [];
List _items3 = [];
Future<void> readJson() async {
  final String response = await rootBundle.loadString("asset/dataheaders.json");
  final data = await json.decode(response);

  _items = data[0];
  _items2 = data[1];
  _items3 = data[2];
}

Widget contentholder(context) {
  readJson();
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
      width: 100,
      height: 100,
      child: Column(
        children: <Widget>[
          _items.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: ((context, index) {
                        return Card(
                            child: Stack(
                          children: [
                            Text(_items[index]["id"]),
                          ],
                        ));
                      })))
              : Container(),
        ],
      ),
    ),
  );
}

// class JsonfromAsset extends StatefulWidget {
//   const JsonfromAsset({Key? key}) : super(key: key);

//   @override
//   State<JsonfromAsset> createState() => _JsonfromAssetState();
// }

// class _JsonfromAssetState extends State<JsonfromAsset> {
//   List<String> userlist = [];

//   Future<String> fetchData() async {
//     String data = await DefaultAssetBundle.of(context)
//         .loadString("asset/dataheaders.json");

//     final jsonResult = json.decode(data);

//     setState(() {
//       jsonResult.forEach(
//           (element) => userlist.add(String.fromJson(User(name, email))));
//     });

//     return "Success!";
//   }

//   @override
//   Widget build(BuildContext context) {
//     fetchData();
//     return Scaffold(
//         body: Container(
//             child: userlist.isNotEmpty
//                 ? ListView.builder(
//                     itemCount: userlist == null ? 0 : userlist.length,
//                     itemBuilder: (context, index) {
//                       return Container(child: Text(userlist[index]));
//                     },
//                   )
//                 : Center(child: Text('empty'))));
//   }
// }

class User {
  final String name;
  final String email;
  User(this.name, this.email);
  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];
}

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
